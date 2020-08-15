import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../model_value.dart';

typedef bool ModelValidator(Map<String, dynamic> update);

class ModelInner extends ModelValue<ModelInner, Map<String, dynamic>> {
  final ModelInner _initialModel;

  final BuiltMap<String, ModelValue> _current;
  final ModelValidator _modelValidator;

  final String _fieldName;

  ModelInner(Map<String, ModelValue> model, [ModelValidator updateValidator, String fieldName])
      : _initialModel = null,
        _current = BuiltMap.of(model),
        _modelValidator = updateValidator,
        _fieldName = fieldName {
    if (!_modelIsValid(_current.toMap())) throw ModelValidationException(this, _current.toMap());
  }

  ModelInner._next(ModelInner last, this._current)
      : _initialModel = last.initialModel,
        _modelValidator = last._modelValidator,
        _fieldName = last._fieldName;

  @override
  ModelInner build(Map<String, dynamic> next) {
    if (next.isEmpty) {
      return this;
    } else {
      final updated = _current.rebuild((mb) {
        next.forEach((field, update) {
          mb.updateValue(
              field,
              (model) => update == null // implies a reset
                  ? model.next(null)
                  : update is ValueUpdater // function update
                      ? model.nextFromFunc(update)
                      : update is ModelValue // model update
                          ? model.nextFromModel(update)
                          : model.nextFromDynamic(update)); // normal value update
        });
      });

      // validate the updated model
      return _modelIsValid(updated.toMap())
          ? ModelInner._next(this, updated)
          : throw ModelValidationException(this, updated.toMap());
    }
  }

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, value) => MapEntry(field, value.value));

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  bool isValid(Map<String, dynamic> toValidate) => true;

  bool _modelIsValid(Map<String, ModelValue> next) => _modelValidator == null || _modelValidator(next);

  ModelInner merge(ModelInner other) {
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

    return ModelInner(thisMap..addAll(otherMap), mergedValidator);
  }

  // not efficient, use sparingly
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_current.toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJSON(Map<String, dynamic> jsonMap) => ModelInner._next(this, _current.rebuild((mb) {
        jsonMap.forEach((field, jsonValue) {
          mb.updateValue(
              field,
              (model) => jsonValue == null || jsonValue == '' // skip nulls and empty strings
                  ? model
                  : model is ModelInner // recursive through the hierarchy
                      ? model.fromJSON(model.deserialize(jsonValue))
                      : model.next(model.deserialize(jsonValue)));
        });
      }));

  // field ops
  Iterable<String> get fields => _current.keys;

  int numberOfFields() => _current.length;

  bool hasField(String field) => _current.containsKey(field);

  ModelValue getFieldModel(String field) => _current[field];

  dynamic getFieldValue(String field) => _current[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  @override
  List<Object> get props => [_current];

  @override
  String get modelFieldName => _fieldName;

  @override
  String toString() => _current.toString();
}
