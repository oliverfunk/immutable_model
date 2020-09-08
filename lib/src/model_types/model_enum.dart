import '../model_type.dart';

class ModelEnum<E> extends ModelType<ModelEnum<E>, String> {
  final E _current;
  final List<E> _enums;

  static String convertEnum<E>(E enumValue) => enumValue.toString().split('.')[1];

  static List<String> convertEnumList<E>(List<E> enumList) =>
      enumList.map((en) => convertEnum(en)).toList(growable: false);

  ModelEnum(
    List<E> enums,
    E initial, [
    String fieldLabel,
  ])  : assert(enums.isNotEmpty, "Provide an enum list using the EnumClass.values method"),
        assert(initial != null, "An inital enum value must be provided"),
        _current = initial,
        _enums = enums,
        super.inital(convertEnum(initial),
            (String toValidate) => convertEnumList(enums).any((enStr) => enStr == toValidate), fieldLabel);

  ModelEnum._next(ModelEnum<E> last, this._current)
      : _enums = last._enums,
        super.fromPrevious(last);

  @override
  ModelEnum<E> buildNext(String nextEnumString) =>
      ModelEnum._next(this, _enums.firstWhere((en) => nextEnumString == convertEnum(en)));

  // public methods

  @override
  String get value => convertEnum(_current);

  List<E> get enums => _enums;

  List<String> get enumStrings => convertEnumList(_enums);

  @override
  String fromSerialized(dynamic jsonValue) =>
      jsonValue is String ? enumStrings.firstWhere((enStr) => enStr == jsonValue, orElse: () => null) : null;

  @override
  String toString() => "<$E>($value)";
}
