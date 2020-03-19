import 'package:flutter/foundation.dart';

typedef Validator<V> = bool Function(V);

abstract class ImmutableModelValue<F extends ImmutableModelValue<F, V>, V> {
  V _value;
  final V defaultValue;

  V get value => _value ?? defaultValue;
  final Validator<V> validator;

  bool _validateIfExists(Validator<V> validator, V value) =>
      validator != null && value != null ? validator(value) : true;

  @mustCallSuper
  ImmutableModelValue([this.defaultValue, this.validator]) {
    assert(_validateIfExists(validator, defaultValue));
  }

  ImmutableModelValue.next(F inst, V nextValue)
      : defaultValue = inst.defaultValue,
        validator = inst.validator {
    assert(_validateIfExists(validator, nextValue));
    _value = nextValue;
  }

  F set(V v);

  F reset();

  dynamic asSerializable();

  F setFrom(v);

  @override
  String toString() => "$value ($F)";
}
