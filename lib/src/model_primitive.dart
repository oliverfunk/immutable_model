import 'exceptions.dart';
import 'model_value.dart';

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final ModelPrimitive<T> _initial;

  final T _current;
  final Validator<T> _validator;
  final String _fieldName;

  ModelPrimitive([T initialValue, Validator<T> validator, String fieldName])
      : _initial = null,
        _current = initialValue,
        _validator = validator,
        _fieldName = fieldName {
    if (initialValue != null) validate(initialValue);
  }

  ModelPrimitive._(ModelPrimitive<T> last, this._current)
      : _initial = last.initialModel,
        _validator = last._validator,
        _fieldName = last._fieldName;

  @override
  T get value => _current;

  @override
  ModelPrimitive<T> get initialModel => _initial ?? this;

  @override
  T validate(T toValidate) => _validator == null
      ? toValidate
      : _validator(toValidate) ? toValidate : throw ModelValidationException(toValidate, modelFieldName);

  @override
  ModelPrimitive<T> build(T nextValue) => ModelPrimitive._(this, nextValue);

  @override
  String get modelFieldName => _fieldName;
}
