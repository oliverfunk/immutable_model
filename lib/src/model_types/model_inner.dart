import 'package:built_collection/built_collection.dart';

import 'model_value.dart';

class ModelInner extends ModelValue<ModelInner, Map<String, dynamic>> {
  final ModelInner _initialModel;

  final BuiltMap<String, ModelValue> _current;

  ModelInner(Map<String, ModelValue> model)
      : _initialModel = null,
        _current = BuiltMap.of(model);

  ModelInner._next(ModelInner last, this._current)
      : _initialModel = last.initialModel;

  // not efficient
  @override
  Map<String, dynamic> get value =>
      _current.toMap().map((field, value) => MapEntry(field, value.value));

  @override
  ModelInner get initialModel => _initialModel ?? this;

  @override
  Map<String, dynamic> validate(Map<String, dynamic> toValidate) => toValidate;

  @override
  ModelInner build(Map<String, dynamic> next) {
    if (next.isEmpty) {
      return this;
    } else {
      return ModelInner._next(this, _current.rebuild((mb) {
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
      }));
    }
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
