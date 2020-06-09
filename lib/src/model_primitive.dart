import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/src/model_value.dart';

typedef bool ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final T _initialValue;
  final T _currentValue;

  final ValueValidator<T> _validator;

  final String _fieldName;

  @override
  String get modelFieldName => _fieldName;

  ModelPrimitive([T initialValue, ValueValidator<T> validator, String fieldName])
      : _currentValue = null,
        _initialValue = initialValue,
        _validator = validator,
        _fieldName = fieldName {
    validate(_initialValue);
  }

  ModelPrimitive._(ModelPrimitive<T> last, this._currentValue)
      : _initialValue = last._initialValue,
        _validator = last._validator,
        _fieldName = last._fieldName;

  T _safeInstance() => _currentValue ?? _initialValue;

  @override
  ModelPrimitive<T> build(T nextValue) =>
      nextValue == null ? ModelPrimitive._(this, _initialValue) : ModelPrimitive._(this, nextValue);

  @override
  T get value => _safeInstance();

  @override
  T validate(T toValidate) => (toValidate == null || _validator == null)
      ? toValidate
      : _validator(toValidate) ? toValidate : throw ModelValidationException(toValidate, modelFieldName);
}
