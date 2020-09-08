import 'model_type.dart';

abstract class ModelValue<M extends ModelType<M, V>, V> extends ModelType<M, V> {
  final V _current;

  @override
  V get value => _current;

  ModelValue.bool([
    bool initialValue,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, null, fieldLabel);

  ModelValue.int([
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, validator as ValueValidator<V>, fieldLabel);

  ModelValue.double([
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, validator as ValueValidator<V>, fieldLabel);

  ModelValue.string([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, validator as ValueValidator<V>, fieldLabel);

  ModelValue.text([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, (str) => str != null && (str as String).isNotEmpty && validator(str as dynamic),
            fieldLabel);

  ModelValue.datetime([
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ])  : _current = initialValue as V,
        super.inital(initialValue as V, validator as ValueValidator<V>, fieldLabel);

  ModelValue.constructNext(M previous, this._current) : super.fromPrevious(previous);
}

mixin ValueType<M extends ModelType<M, V>, V> on ModelValue<M, V> {
  @override
  M buildFromModel(M previous) => buildNext(previous.value);

  @override
  bool hasEqualityOfHistory(ModelType other) => other is M;
}
