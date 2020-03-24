import 'package:meta/meta.dart';

typedef ValueValidator<V> = void Function(V);
typedef ValueSerializer<V> = dynamic Function(V);
typedef ValueDeserializer<V> = V Function(dynamic);

abstract class ImmutableModelValue<F extends ImmutableModelValue<F, V>, V> {
  final ValueSerializer<V> serializer;
  final ValueDeserializer<V> deserializer;
  final ValueValidator<V> validator;

  V _value;
  final V defaultValue;

  V get value => _value ?? defaultValue;

  V _safeValidateValue(V value) {
    if (validator != null && value != null) validator(value);
    return value;
  }

  ImmutableModelValue({@required this.serializer, @required this.deserializer, this.defaultValue, this.validator}) {
    _value = _safeValidateValue(defaultValue);
  }

  ImmutableModelValue.next(F instance, V nextValue)
      : serializer = instance.serializer,
        deserializer = instance.deserializer,
        defaultValue = instance.defaultValue,
        validator = instance.validator {
    _value = _safeValidateValue(nextValue);
  }

  F set(V v);

  F reset() => set(null);

  F setFrom(v) => set(deserializer(v));

  dynamic asSerializable() => serializer(value);

  @override
  String toString() => "$value ($V)";
}

class ValueTypeException implements Exception {
  final Type expected;
  final Type received;
  final dynamic value;

  ValueTypeException(this.expected, this.received, this.value);

  @override
  String toString() => 'Expected $expected but got $received: $value';
}
