import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../model_value.dart';

//todo: abstact out _buildUpdate

/// note [modelMap] is unmodifable
typedef bool ModelValidator(Map<String, dynamic> modelMap);

class ModelInner extends ModelValue<ModelInner, Map<String, dynamic>> {
  final ModelInner _initialModel;

  final BuiltMap<String, ModelValue> _current;
  final ModelValidator _modelValidator;
  final bool strictUpdates;

  final String _fieldLabel;

  ModelInner(
    Map<String, ModelValue> model, [
    ModelValidator modelValidator,
    this.strictUpdates = false,
    String fieldLabel,
  ])  : assert(model != null && model.isNotEmpty, "The model cannot be null and must have fields"),
        _initialModel = null,
        _current = BuiltMap.of(model),
        _modelValidator = modelValidator,
        _fieldLabel = fieldLabel;

  ModelInner._next(ModelInner last, this._current)
      : _initialModel = last.initialModel,
        _modelValidator = last._modelValidator,
        strictUpdates = last.strictUpdates,
        _fieldLabel = last._fieldLabel;

  @override
  ModelInner build(Map<String, dynamic> next) => strictUpdates
      ? ModelInner._next(this, _validateModel(_buildFromNext(_validateStrict(next))))
      : next.isEmpty ? this : ModelInner._next(this, _validateModel(_buildFromNext(next)));

  BuiltMap<String, dynamic> _buildFromNext(Map<String, dynamic> next) => _current.rebuild((mb) {
        next.forEach((updateField, updateValue) {
          hasField(updateField)
              ? mb.updateValue(
                  updateField,
                  (currentModel) => updateValue == null
                      ? currentModel.next(null)
                      : updateValue is ModelValue // model update
                          ? currentModel.nextFromModel(updateValue)
                          : updateValue is ValueUpdater // function update
                              ? currentModel.nextFromFunc(updateValue)
                              : currentModel.nextFromDynamic(updateValue)) // normal value update
              : throw ImmutableModelUpdateException(this, next, "Field '$updateField' not in this model.");
        });
      });

  BuiltMap<String, ModelValue> _validateModel(BuiltMap<String, ModelValue> toValidate) =>
      _checkModel(toValidate.asMap()) ? toValidate : throw ImmutableModelValidationException(this, toValidate.asMap());

  bool _checkModel(Map<String, ModelValue> next) => _modelValidator == null || _modelValidator(next);

  Map<String, dynamic> _validateStrict(Map<String, dynamic> update) => _checkStrict(update)
      ? update
      : throw ImmutableModelUpdateException(
          this, update, "Some model fields were not present in the update or the value was null.");

  /*
  * Checks if every field in the model is in the update and has a value.
  */
  bool _checkStrict(Map<String, dynamic> update) =>
      fields.every((field) => update.containsKey(field) && update[field] != null);

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, value) => MapEntry(field, value.value));

  Map<String, ModelValue> get asModelMap => _current.asMap();

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  bool checkValid(Map<String, dynamic> toValidate) => true;

  ModelInner merge(ModelInner other) => hasEqualityOfHistory(other)
      ? ModelInner._next(this, _validateModel(_buildMergeOther(other.asModelMap)))
      : throw ImmutableModelEqualityException(this, other);

  BuiltMap<String, dynamic> _buildMergeOther(Map<String, ModelValue> other) => _current.rebuild((mb) {
        other.forEach((otherField, otherModel) {
          hasField(otherField)
              ? mb.updateValue(
                  otherField,
                  (currentModel) => currentModel is ModelInner
                      ? currentModel.merge(otherModel)
                      : otherModel.isInitial // checks if deafult value
                          ? currentModel
                          : currentModel.nextFromModel(otherModel)) // could possible replace with with just otherModel
              : throw ImmutableModelUpdateException(
                  this, other, "Merge failed. Field '$otherField' not in this model.");
        });
      });

  /// Join two models together. Values from other will over-wrtie values in this
  ModelInner join(
    ModelInner other, [
    bool strictUpdates = false,
    String fieldLabel,
  ]) {
    ModelValidator mergedValidator;
    if (_modelValidator == null) {
      if (other._modelValidator == null) {
        // both null
        mergedValidator = null;
      } else {
        // only other not null
        mergedValidator = other._modelValidator;
      }
    } else {
      if (other._modelValidator == null) {
        // only this not null
        mergedValidator = _modelValidator;
      } else {
        // both not null
        mergedValidator = (map) => _modelValidator(map) && other._modelValidator(map);
      }
    }

    final mergedModelMaps = _current.toMap()..addAll(other._current.toMap());

    return ModelInner(mergedModelMaps, mergedValidator, strictUpdates, fieldLabel);
  }

  // not efficient, use sparingly retured map is unmodifable, if you want moidifabl euse value
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_current.toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJson(dynamic jsonMap) => strictUpdates
      ? ModelInner._next(this, _validateModel(_buildFromJson(_validateStrict(fromSerialized(jsonMap)))))
      : ModelInner._next(this, _validateModel(_buildFromJson(fromSerialized(jsonMap))));

  BuiltMap<String, ModelValue> _buildFromJson(Map<String, dynamic> jsonMap) => _current.rebuild((mb) {
        jsonMap.forEach((jsonField, jsonValue) {
          if (hasField(jsonField)) {
            // skip fields not in model
            mb.updateValue(
                jsonField,
                (currentModel) => jsonValue == null || jsonValue == '' // skip nulls and empty strings
                    ? currentModel
                    : currentModel is ModelInner
                        ? currentModel.fromJson(jsonValue)
                        : currentModel.nextFromSerialized(jsonValue));
          }
        });
      });

  // field ops
  Iterable<String> get fields => _current.keys;

  bool hasField(String field) => _current.containsKey(field);

  int get numberOfFields => _current.length;

  ModelValue fieldModel(String field) => hasField(field) ? _current[field] : null;

  dynamic fieldValue(String field) {
    final fm = fieldModel(field);
    if (fm == null) {
      throw ImmutableModelAccessException(this, field);
    }
    return fm is ModelInner ? fm : fm.value;
  }

  dynamic operator [](String field) => fieldValue(field);

  ModelInner resetFields(List<String> fields) => isInitial
      ? this
      : ModelInner._next(this, _current.rebuild((mb) {
          fields.forEach((field) {
            hasField(field)
                ? mb.updateValue(
                    field, (currentModel) => currentModel is ModelInner ? currentModel.resetAll() : initialModel[field])
                : throw ImmutableModelUpdateException(this, fields, "Field '$field' not in model.");
          });
        }));

  ModelInner resetAll() => initialModel;

  @override
  List<Object> get props => [_current];

  @override
  String get fieldLabel => _fieldLabel;

  @override
  String toString() => _current.toString();
}
