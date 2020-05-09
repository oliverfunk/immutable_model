import 'package:immutable_model/src/model_value.dart';

typedef V ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final T _initialValue;
  final T _currentValue;

  final ValueValidator<T> _validator;

  ModelPrimitive([T initialValue, ValueValidator<T> validator])
      : _initialValue = initialValue,
        _currentValue = initialValue,
        _validator = validator {
    validate(_initialValue);
  }

  ModelPrimitive._(ModelPrimitive<T> last, this._currentValue)
      : _initialValue = last._initialValue,
        _validator = last._validator;

  @override
  ModelPrimitive<T> build(T nextValue) =>
      nextValue == null ? ModelPrimitive(this._initialValue, this._validator) : ModelPrimitive._(this, nextValue);

  @override
  T get value => _currentValue;

  T validate(T toValidate) =>
      _validator == null ? toValidate : toValidate == null ? throw Error() : _validator(toValidate);
}
