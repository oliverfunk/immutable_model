import '../model_value.dart';

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final T _current;

  // constructors

  ModelPrimitive.bool([
    bool initialValue,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, null, fieldLabel);

  ModelPrimitive.int([
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, validator as ValueValidator<T>, fieldLabel);

  ModelPrimitive.double([
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, validator as ValueValidator<T>, fieldLabel);

  ModelPrimitive.string([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, validator as ValueValidator<T>, fieldLabel);

  ModelPrimitive.text([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, (str) => str != null && (str as String).isNotEmpty && validator(str as dynamic),
            fieldLabel);

  ModelPrimitive.datetime([
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ])  : _current = initialValue as T,
        super.inital(initialValue as T, validator as ValueValidator<T>, fieldLabel);

  ModelPrimitive.constructNext(ModelPrimitive<T> last, T next)
      : _current = last.validate(next) ? next : last._current,
        super.fromLast(last);

  ModelPrimitive._next(ModelPrimitive<T> last, this._current) : super.fromLast(last);

  @override
  ModelPrimitive<T> build(T nextValue) => ModelPrimitive._next(this, nextValue);

  // methods

  @override
  T get value => _current;

  @override
  dynamic asSerializable() => T == DateTime ? (value as DateTime).toIso8601String() : value;

  @override
  T fromSerialized(dynamic serialized) =>
      (T == DateTime && serialized is String) ? DateTime.parse(serialized) as T : serialized is T ? serialized : null;
}
