import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../model_value.dart';

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
  ])  : _initialModel = null,
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
      ? ModelInner._next(this, _validateModel(_buildFromNext(_validateUpdate(next))))
      : next.isEmpty ? this : ModelInner._next(this, _validateModel(_buildFromNext(next)));

  BuiltMap<String, dynamic> _buildFromNext(Map<String, dynamic> next) => _current.rebuild((mb) {
        next.forEach((field, update) {
          mb.updateValue(
              field,
              (currentModel) => update == null
                  ? currentModel.next(null)
                  : update is ModelValue // model update
                      ? currentModel.nextFromModel(update)
                      : update is ValueUpdater // function update
                          ? currentModel.nextFromFunc(update)
                          : currentModel.nextFromDynamic(update)); // normal value update
        });
      });

  BuiltMap<String, ModelValue> _validateModel(BuiltMap<String, ModelValue> toValidate) =>
      _checkModel(toValidate.asMap()) ? toValidate : throw ImmutableModelValidationException(this, toValidate.asMap());

  bool _checkModel(Map<String, ModelValue> next) => _modelValidator == null || _modelValidator(next);

  Map<String, dynamic> _validateUpdate(Map<String, dynamic> update) =>
      _checkUpdate(update) ? update : throw ImmutableModelStructureException(fields, update.keys);

  bool _checkUpdate(Map<String, dynamic> update) =>
      update.length == numberOfFields && update.entries.every((entry) => hasField(entry.key) && entry.value != null);

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, value) => MapEntry(field, value.value));

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  bool checkValid(Map<String, dynamic> toValidate) => true;

  ModelInner merge(ModelInner other) => hasEqualityOfHistory(other)
      ? ModelInner._next(this, _validateModel(_buildMergeOther(other._current.asMap())))
      : throw ImmutableModelEqualityException(this, other);

  BuiltMap<String, dynamic> _buildMergeOther(Map<String, ModelValue> other) => _current.rebuild((mb) {
        other.forEach((otherField, otherModel) {
          mb.updateValue(
              otherField,
              (currentModel) => currentModel is ModelInner
                  ? currentModel.merge(otherModel)
                  : otherModel.isInitial // checks if deafult value
                      ? currentModel
                      : currentModel.nextFromModel(otherModel)); // could possible replace with with just otherModel
        });
      });

  /// Join two models together. Values from other will over-wrtie values in this
  /// ! remeber to do the state in IM
  ModelInner join(ModelInner other) {
    final thisMap = _current.toMap();
    final otherMap = other._current.toMap();

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

    final mergedModel = thisMap..addAll(otherMap);

    return _checkModel(mergedModel)
        ? ModelInner(mergedModel, mergedValidator)
        : throw ImmutableModelValidationException(this, mergedModel);
  }

  // not efficient, use sparingly retured map is unmodifable, if you want moidifabl euse value
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_current.toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJson(dynamic jsonMap) => strictUpdates
      ? ModelInner._next(this, _validateModel(_buildFromJson(_validateUpdate(fromSerialized(jsonMap)))))
      : ModelInner._next(this, _validateModel(_buildFromJson(fromSerialized(jsonMap))));

  BuiltMap<String, ModelValue> _buildFromJson(Map<String, dynamic> jsonMap) => _current.rebuild((mb) {
        jsonMap.forEach((field, jsonValue) {
          mb.updateValue(
              field,
              (currentModel) => jsonValue == null || jsonValue == '' // skip nulls and empty strings
                  ? currentModel
                  : currentModel is ModelInner
                      ? currentModel.fromJson(jsonValue)
                      : currentModel.nextFromSerialized(jsonValue));
        });
      });

  // field ops
  Iterable<String> get fields => _current.keys;

  bool hasField(String field) => _current.containsKey(field);

  int get numberOfFields => _current.length;

  ModelValue getFieldModel(String field) => _current[field];

  dynamic getFieldValue(String field) => _current[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  ModelInner resetFields(List<String> fields) => isInitial
      ? this
      : ModelInner._next(this, _current.rebuild((mb) {
          fields.forEach((field) {
            mb.updateValue(
                field, (currentModel) => currentModel is ModelInner ? currentModel.resetAll() : initialModel[field]);
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
