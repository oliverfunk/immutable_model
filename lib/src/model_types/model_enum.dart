import '../model_value.dart';

class ModelEnum<E> extends ModelValue<ModelEnum<E>, String> {
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

  ModelEnum._next(ModelEnum<E> last, this._current)
      : _initialModel = last.initialModel,
        _enums = last._enums,
        _fieldLabel = last._fieldLabel;

  @override
  ModelEnum<E> build(String nextEnumString) =>
      ModelEnum._next(this, _enums.firstWhere((en) => nextEnumString == convertEnum(en)));

  // public methods

  @override
  String get value => convertEnum(_current);

  List<E> get enums => _enums;

  List<String> get enumStrings => _enums.map((en) => convertEnum(en)).toList(growable: false);

  @override
  ModelEnum<E> get initialModel => _initialModel ?? this;

  @override
  bool checkValid(String toValidate) => enumStrings.any((enStr) => enStr == toValidate);

  @override
  String fromSerialized(dynamic jsonValue) =>
      jsonValue is String ? enumStrings.firstWhere((enStr) => enStr == jsonValue, orElse: () => null) : null;

  @override
  String get fieldLabel => _fieldLabel;

  @override
  String toString() => "<$E>($value)";
}
