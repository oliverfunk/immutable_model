import 'exceptions.dart';
import 'model_value.dart';

typedef bool ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final ModelPrimitive<T> _initial;

  final T _current;
  final ValueValidator<T> _validator;
  final String _fieldName;

  ModelPrimitive([T initialValue, ValueValidator<T> validator, String fieldName])
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
      : _validator(toValidate) ? toValidate : throw ModelValidationException(this, toValidate);

  @override
  ModelPrimitive<T> build(T nextValue) => ModelPrimitive._(this, nextValue);

  @override
  String get modelFieldName => _fieldName;
}
