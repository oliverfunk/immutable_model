import '../exceptions.dart';
import '../model_value.dart';

// make sure using the enum object works, esp with equ adn equofHist
// serialsie and derislase using enum <-> string methods
// ensure structure

class ModelEnum<E> extends ModelValue<ModelEnum<E>, E> {
  final ModelEnum _initialModel;

  final E _current;
  final List<E> _enums;

  final String _fieldName;

  // constructors

  ModelEnum.fromEnumList(List<E> enums, E initial, [String fieldName])
      : _initialModel = null,
        _current = initial,
        _enums = enums,
        _fieldName = fieldName;

  ModelEnum._next(ModelEnum last, this._current)
      : _initialModel = last.initialModel,
        _enums = last._enums,
        _fieldName = last._fieldName;

  @override
  ModelEnum<E> build(E nextEnum) => ModelEnum._next(this, nextEnum);

  // static methods

  static String convertEnum<E>(E enumValue) => enumValue.toString().split('.')[1];

  // public methods

  @override
  E get value => _current;

  @override
  ModelEnum<E> get initialModel => _initialModel ?? this;

  @override
  bool isValid(E toValidate) => true; // by defintion, if it's of [E], is valid

  @override
  dynamic asSerializable() => convertEnum(value);

  @override
  E deserialize(dynamic jsonValue) => jsonValue is String
      ? _enums.firstWhere((en) => convertEnum(en) == jsonValue)
      : throw ModelFromJsonException(this, jsonValue);

  @override
  String get modelFieldName => _fieldName;

  @override
  String toString() => "<$E>($value)";
}
