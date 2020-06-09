import 'package:built_collection/built_collection.dart';

import 'model_value.dart';

typedef dynamic FieldUpdater(dynamic currentValue);

class ModelInner extends ModelValue<ModelInner, Map<String, dynamic>> {
  final ModelInner _initial;

  final BuiltMap<String, ModelValue> _current;

  ModelInner._(ModelInner last, this._current) : _initial = last.initialModel;

  ModelInner(Map<String, ModelValue> model)
      : _initial = null,
        _current = BuiltMap.of(model);

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, value) => MapEntry(field, value.value));

  @override
  ModelInner get initialModel => _initial ?? this;

  @override
  ModelInner build(Map<String, dynamic> next) {
    if (next.isEmpty) {
      return this;
    } else {
      return ModelInner._(this, _current.rebuild((mb) {
        next.forEach((field, update) {
          mb.updateValue(
              field,
              (currVal) => update is FieldUpdater
                  ? currVal.nextFromDynamic(update(currVal.value))
                  : currVal.nextFromDynamic(update));
        });
      }));
    }
  }

  // not efficient
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_current.toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJSON(Map<String, dynamic> jsonMap) => ModelInner._(this, _current.rebuild((mb) {
        jsonMap.forEach((field, jsonValue) {
          mb.updateValue(field,
              (currVal) => currVal is ModelInner
                  ? currVal.fromJSON(currVal.deserializer(jsonValue))
                  : currVal.next(currVal.deserializer(jsonValue)));
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
