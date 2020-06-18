import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import 'model_value.dart';

typedef bool UpdateValidator(Map<String, dynamic> update);

class ModelInner extends ModelValue<ModelInner, Map<String, dynamic>> {
  final ModelInner _initialModel;

  final BuiltMap<String, ModelValue> _current;
  final UpdateValidator _updateValidator;

  ModelInner(Map<String, ModelValue> model, [UpdateValidator updateValidator])
      : _initialModel = null,
        _updateValidator = updateValidator,
        _current = BuiltMap.of(model) {
    _postProcess(_current);
  }

  ModelInner._next(ModelInner last, this._current)
      : _initialModel = last.initialModel,
        _updateValidator = last._updateValidator;

  // not efficient
  @override
  Map<String, dynamic> get value =>
      _current.toMap().map((field, value) => MapEntry(field, value.value));

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  Map<String, dynamic> validate(Map<String, dynamic> toValidate) => toValidate;

  ModelInner _postProcess(BuiltMap<String, ModelValue> next) {
    if (_updateValidator == null || _updateValidator(next.toMap())) {
      return ModelInner._next(this, next);
    } else {
      throw ModelValidationException(this, next.toMap());
    }
  }

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
                          : model
                              .nextFromDynamic(update)); // normal value update
        });
      });

      // post-processing validation
      return _postProcess(updated);
    }
  }

  ModelInner merge(ModelInner other) {
    final thisMap = _current.toMap();
    final otherMap = other._current.toMap();

    UpdateValidator mergedValidator;
    if (_updateValidator == null) {
      if (other._updateValidator == null) {
        // both null
        mergedValidator = null;
      } else {
        // only other not null
        mergedValidator = other._updateValidator;
      }
    } else {
      if (other._updateValidator == null) {
        // only this not null
        mergedValidator = _updateValidator;
      } else {
        // both not null
        mergedValidator =
            (map) => _updateValidator(map) && other._updateValidator(map);
      }
    }

    return ModelInner(thisMap..addAll(otherMap), mergedValidator);
  }

// not efficient, use sparingly
  @override
  Map<String, dynamic> asSerializable() => Map.unmodifiable(_current
      .toMap()
      .map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJSON(Map<String, dynamic> jsonMap) =>
      ModelInner._next(this, _current.rebuild((mb) {
        jsonMap.forEach((field, jsonValue) {
          mb.updateValue(
              field,
              (model) => jsonValue == null ||
                      jsonValue == '' // skip nulls and empty strings
                  ? model
                  : model is ModelInner // recursive through the hierarchy
                      ? model.fromJSON(model.deserializer(jsonValue))
                      : model.next(model.deserializer(jsonValue)));
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
  String toString() => _current.toString();
}
