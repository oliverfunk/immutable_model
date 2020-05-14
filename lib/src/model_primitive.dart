import 'package:immutable_model/src/model_value.dart';

typedef V ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final T _initialValue;
  final T _currentValue;

  final ValueValidator<T> _validator;

  ModelPrimitive([T initialValue, ValueValidator<T> validator])
      : _currentValue = null,
        _initialValue = initialValue,
        _validator = validator {
    validate(_initialValue);
  }

  ModelPrimitive._(ModelPrimitive<T> last, this._currentValue)
      : _initialValue = last._initialValue,
        _validator = last._validator;

  T _safeInstance() => _currentValue ?? _initialValue;

  @override
  ModelPrimitive<T> build(T nextValue) =>
      nextValue == null ? ModelPrimitive._(this, _initialValue) : ModelPrimitive._(this, nextValue);

  @override
  T get value => _safeInstance();

  @override
  T validate(T toValidate) => (toValidate == null || _validator == null) ? toValidate : _validator(toValidate);
}
