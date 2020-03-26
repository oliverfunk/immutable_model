import '../immutable_entity.dart';

typedef void Validator<V>(V value);

class ImmutableValue<V> extends ImmutableEntity<V> {
  final V _value;
  final V _defaultValue;
  final Validator<V> validator;

  ImmutableValue._([ImmutableValue instance, V nextValue])
      : _value = nextValue,
        _defaultValue = instance._defaultValue,
        validator = instance.validator;

  ImmutableValue([this._defaultValue, this.validator]) : _value = null;

  V _safeValidate(V valueToValidate) {
    if (validator != null && valueToValidate != null) validator(valueToValidate);
    return valueToValidate;
  }

  @override
  V get value => _value ?? _defaultValue;

  @override
  V validate(V valueToValidate) => _safeValidate(valueToValidate);

  @override
  ImmutableValue<V> build(V nextValue) => ImmutableValue._(this, nextValue);
}
