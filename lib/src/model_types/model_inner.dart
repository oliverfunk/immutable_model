import 'package:built_collection/built_collection.dart';

import '../immutable_model.dart';
import 'model_value.dart';

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
              (model) => update == null // implies a reset
                  ? model.next(null)
                  : update is ValueUpdater // func update
                      ? model.nextFromFunc(update)
                      : update is ModelValue // model update
                          ? model.nextFromModel(update)
                          : model.nextFromDynamic(update)); // normal value update
        });
      }));
    }
  }

  // not efficient, use sparingly
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_current.toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ModelInner fromJSON(Map<String, dynamic> jsonMap) => ModelInner._(this, _current.rebuild((mb) {
        jsonMap.forEach((field, jsonValue) {
          mb.updateValue(
              field,
              (model) => jsonValue == null // skip nulls
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
