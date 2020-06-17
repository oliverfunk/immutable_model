import '../exceptions.dart';
import 'model_value.dart';

typedef bool ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final ModelPrimitive<T> _initialModel;

  final T _current;
  final ValueValidator<T> _validator;
  final String _fieldName;

  // constructors

  ModelPrimitive.bool(bool initial, [String fieldName])
      : _initialModel = null,
        _current = initial as T,
        _validator = null,
        _fieldName = fieldName;

  ModelPrimitive.int([int initial, ValueValidator<int> validator, String fieldName])
      : _initialModel = null,
        _current = initial as T,
        _validator = validator as ValueValidator<T>,
        _fieldName = fieldName {
    if (_current != null) validate(_current);
  }

  ModelPrimitive.double([double initial, ValueValidator<double> validator, String fieldName])
      : _initialModel = null,
        _current = initial as T,
        _validator = validator as ValueValidator<T>,
        _fieldName = fieldName {
    if (_current != null) validate(_current);
  }

  ModelPrimitive.string([String initial, ValueValidator<String> validator, String fieldName])
      : _initialModel = null,
        _current = initial as T,
        _validator = validator as ValueValidator<T>,
        _fieldName = fieldName {
    if (_current != null) validate(_current);
  }

  ModelPrimitive.datetime([DateTime initial, ValueValidator<DateTime> validator, String fieldName])
      : _initialModel = null,
        _current = initial as T,
        _validator = validator as ValueValidator<T>,
        _fieldName = fieldName {
    if (_current != null) validate(_current);
  }

  ModelPrimitive._next(ModelPrimitive<T> last, this._current)
      : _initialModel = last.initialModel,
        _validator = last._validator,
        _fieldName = last._fieldName;

  @override
  ModelPrimitive<T> build(T nextValue) => ModelPrimitive._next(this, nextValue);

  // methods

  @override
  T get value => _current;

  @override
  ModelPrimitive<T> get initialModel => _initialModel ?? this;

  @override
  T validate(T toValidate) => _validator == null
      ? toValidate
      : _validator(toValidate) ? toValidate : throw ModelValidationException(this, toValidate);
}
