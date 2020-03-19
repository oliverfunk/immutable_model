import 'package:built_collection/built_collection.dart';

typedef Validator<T> = bool Function(T);

class ImmutableFieldValue<T> {
  T _value;

  T get value => _value ?? defaultValue;

  final T defaultValue;
  final Validator<T> validator;

  ImmutableFieldValue._(ImmutableFieldValue<T> f, T newValue)
      : defaultValue = f.defaultValue,
        validator = f.validator {
    if (validator != null && newValue != null) {
      assert(validator(newValue));
    }
    _value = newValue;
  }

  ImmutableFieldValue([this.defaultValue, this.validator]) {
    if (validator != null && defaultValue != null) {
      assert(validator(defaultValue));
    }
  }

  dynamic asSerializable() => value;

  ImmutableFieldValue<T> setWithParse(dynamic v) =>
      v is T ? set(v) : throw Exception('T is $T, but v is ${v.runtimeType} with:\n$v');

  ImmutableFieldValue<T> set(T v) => ImmutableFieldValue<T>._(this, v);

  ImmutableFieldValue<T> reset() => ImmutableFieldValue<T>._(this, null);

  @override
  String toString() => "$value ($T)";
}

class ImmutableModel {
  final BuiltMap<String, ImmutableFieldValue> _model;

  ImmutableModel._(this._model);

  ImmutableModel(Map<String, ImmutableFieldValue> model) : _model = model.build();

  ImmutableModel updateWith(Map<String, dynamic> updates) => ImmutableModel._(_model.rebuild((mb) {
        updates.forEach((field, value) {
          mb.updateValue(field, (cv) => cv.setWithParse(value));
        });
      }));

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(_model.rebuild((mb) {
        fields.forEach((field) {
          mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  ImmutableModel resetAll() => ImmutableModel._(_model.rebuild((mb) => mb.updateAllValues((k, v) => v.reset())));

  Map<String, dynamic> asMap() => Map<String, dynamic>.unmodifiable(Map<String, dynamic>.fromIterable(
      _model.entries,
      key: (entry) => entry.key,
      value: (entry) => entry.value.asSerializable()
  ));

  @override
  String toString() => _model.toString();
}
