import 'package:meta/meta.dart';

import '../model_value.dart';

typedef bool ValueValidator<V>(V value);

class ModelPrimitive<T> extends ModelValue<ModelPrimitive<T>, T> {
  final ModelPrimitive<T> _initialModel;

  final T _current;
  final ValueValidator<T> _validator;

  final String _fieldLabel;

  // constructors

  ModelPrimitive.bool([
    bool initialValue,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = initialValue as T,
        _validator = null,
        _fieldLabel = fieldLabel;

  ModelPrimitive.int([
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = initialValue as T,
        _validator = validator as ValueValidator<T>,
        _fieldLabel = fieldLabel;

  ModelPrimitive.double([
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = initialValue as T,
        _validator = validator as ValueValidator<T>,
        _fieldLabel = fieldLabel;

  ModelPrimitive.string([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = initialValue as T,
        _validator = validator as ValueValidator<T>,
        _fieldLabel = fieldLabel;

  ModelPrimitive.datetime([
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = initialValue as T,
        _validator = validator as ValueValidator<T>,
        _fieldLabel = fieldLabel;

  @protected
  ModelPrimitive.constructNext(ModelPrimitive<T> last, this._current)
      : _initialModel = last.initialModel,
        _validator = last._validator,
        _fieldLabel = last._fieldLabel;

  @override
  ModelPrimitive<T> build(T nextValue) => ModelPrimitive.constructNext(this, nextValue);

  // methods

  @override
  T get value => _current;

  @override
  ModelPrimitive<T> get initialModel => _initialModel ?? this;

  @override
  bool checkValid(T toValidate) => _validator == null || _validator(toValidate);

  @override
  dynamic asSerializable() => T == DateTime ? (value as DateTime).toIso8601String() : value;

  @override
  T fromSerialized(dynamic serialized) =>
      (T == DateTime && serialized is String) ? DateTime.parse(serialized) as T : serialized is T ? serialized : null;

  // {
  //   if (T == DateTime) {
  //     if (jsonValue is String) {
  //       return DateTime.parse(jsonValue) as T;
  //     } else {
  //       throw ImmutableModelDeserialisationException(this, jsonValue);
  //     }
  //   } else {
  //     if (jsonValue is T) {
  //       return jsonValue;
  //     } else {
  //       throw ImmutableModelDeserialisationException(this, jsonValue);
  //     }
  //   }
  // }

  @override
  String get fieldLabel => _fieldLabel;
}
