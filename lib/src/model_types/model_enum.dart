import '../exceptions.dart';
import '../model_value.dart';

class ModelEnum<E> extends ModelValue<ModelEnum<E>, E> {
  final ModelEnum _initialModel;

  final E _current;
  final List<E> _enums;

  final String _fieldLabel;

  static String convertEnum<E>(E enumValue) => enumValue.toString().split('.')[1];

  // constructors

  ModelEnum.fromEnumList(
    List<E> enums,
    E initial, [
    String fieldLabel,
  ])  : assert(enums.isNotEmpty, "Provide an enum list using the EnumClass.values method"),
        assert(initial != null, "An inital enum value must be provided"),
        _initialModel = null,
        _current = initial,
        _enums = enums,
        _fieldLabel = fieldLabel;

  ModelEnum._next(ModelEnum last, this._current)
      : _initialModel = last.initialModel,
        _enums = last._enums,
        _fieldLabel = last._fieldLabel;

  @override
  ModelEnum<E> build(E nextEnum) => ModelEnum._next(this, nextEnum);

  // public methods

  @override
  E get value => _current;

  @override
  ModelEnum<E> get initialModel => _initialModel ?? this;

  @override
  bool checkValid(E toValidate) => true; // by defintion, if it's of [E], is valid

  @override
  dynamic asSerializable() => convertEnum(value);

  @override
  E fromSerialized(dynamic jsonValue) => jsonValue is String
      ? _enums.firstWhere(
          (en) => convertEnum(en) == jsonValue,
          orElse: () => throw ImmutableModelDeserialisationException(this, jsonValue),
        )
      : throw ImmutableModelDeserialisationException(this, jsonValue);

  @override
  String get fieldLabel => _fieldLabel;
}
