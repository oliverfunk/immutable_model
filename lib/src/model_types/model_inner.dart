import 'package:built_collection/built_collection.dart';

import '../../model_types.dart';
import '../model_value.dart';

import '../utils/log.dart';
import '../exceptions.dart';
import '../errors.dart';

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

  BuiltMap<String, ModelValue> _validateModel(BuiltMap<String, ModelValue> toValidate) =>
      (_modelValidator == null || _modelValidator(toValidate.asMap()))
          ? toValidate
          : logExceptionAndReturn(_current, ValidationException(this, toValidate));

  ModelInner _builder(
    Map<String, dynamic> update,
    BuiltMap<String, dynamic> Function(Map<String, dynamic> update) mapBuilder,
  ) =>
      (strictUpdates && !checkUpdateStrictly(update))
          ? logExceptionAndReturn(this, StrictUpdateException(this, update))
          : update.isEmpty ? this : ModelInner._next(this, _validateModel(mapBuilder(update)));

  BuiltMap<String, dynamic> _buildFromNext(Map<String, dynamic> next) => _current.rebuild((mb) {
        next.forEach((field, nextValue) {
          hasField(field)
              ? mb.updateValue(
                  field,
                  (currentModel) => nextValue == null
                      ? currentModel.next(null)
                      : nextValue is ModelValue // model update
                          ? currentModel.nextFromModel(nextValue)
                          : nextValue is ValueUpdater // function update
                              ? currentModel.nextFromFunc(nextValue)
                              : currentModel.nextFromDynamic(nextValue)) // normal value update
              : throw ModelAccessError(this, field);
        });
      });

  BuiltMap<String, ModelValue> _buildFromJson(Map<String, dynamic> jsonMap) => _current.rebuild((mb) {
        jsonMap.forEach((jsonField, jsonValue) {
          // skip fields not in model
          if (hasField(jsonField)) {
            mb.updateValue(
                jsonField,
                (currentModel) => jsonValue == null || jsonValue == '' // skip nulls and empty strings
                    ? currentModel
                    : currentModel is ModelInner
                        ? currentModel.fromJson(fromSerialized(jsonValue))
                        : currentModel.nextFromSerialized(jsonValue));
          }
        });
      });

  @override
  ModelInner build(Map<String, dynamic> next) => _builder(next, _buildFromNext);

  /*
  * Checks if every field in the model is in the update and has a value.
  */
  bool checkUpdateStrictly(Map<String, dynamic> update) =>
      fieldLabels.every((field) => update.containsKey(field) && update[field] != null);

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, value) => MapEntry(field, value.value));

  Map<String, ModelValue> get asModelMap => _current.asMap();

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  bool checkValid(Map<String, dynamic> toValidate) => true;

  ModelInner merge(ModelInner other) => hasEqualityOfHistory(other)
      ? ModelInner._next(this, _buildMergeOther(other.asModelMap))
      : throw ModelHistoryEqualityError(this, other);

  BuiltMap<String, dynamic> _buildMergeOther(Map<String, ModelValue> other) => _current.rebuild((mb) {
        other.forEach((otherField, otherModel) {
          mb.updateValue(
              otherField,
              (currentModel) => currentModel is ModelInner
                  ? currentModel.merge(otherModel)
                  : otherModel.isInitial ? currentModel.isInitial ? otherModel : currentModel : otherModel);
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

  ModelInner fromJson(dynamic jsonMap) => _builder(jsonMap, (jsonMap) => _buildFromJson(fromSerialized(jsonMap)));

  // field ops
  Iterable<String> get fieldLabels => _current.keys;

  bool hasField(String field) => _current.containsKey(field);

  int get numberOfFields => _current.length;

  ModelValue fieldModel(String field) => hasField(field) ? _current[field] : throw ModelAccessError(this, field);

  dynamic fieldValue(String field) => fieldModel(field).value;

  dynamic operator [](String field) {
    final fm = fieldModel(field);
    return fm is ModelInner ? fm : fm.value;
  }

  ModelInner resetFields(List<String> fields) => isInitial
      ? this
      : ModelInner._next(this, _current.rebuild((mb) {
          fields.forEach((field) {
            hasField(field)
                ? mb.updateValue(
                    field, (currentModel) => currentModel is ModelInner ? currentModel.reset() : initialModel[field])
                : throw ModelAccessError(this, field);
          });
        }));

  ModelInner reset() => initialModel;

  @override
  List<Object> get props => [_current];

  @override
  String get fieldLabel => _fieldLabel;

  @override
  String toString() => _current.toString();
}
