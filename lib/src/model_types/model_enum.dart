import '../model_type.dart';

/// A model for an enum.
class ModelEnum<E> extends ModelType<ModelEnum<E>, String> {
  final E _current;
  final List<E> _enums;

  /// Returns [enumValue] as a [String].
  ///
  /// Only the name of the enum instance is returned, the class's name is stripped out.
  static String convertEnum<E>(E enumValue) => enumValue.toString().split('.')[1];

  /// Converts [enumValues] to a list of Strings.
  ///
  /// [enumValues] should come from calling the static `.values` getter on the enum class.
  static List<String> convertEnumList<E>(List<E> enumValues) =>
      enumValues.map((en) => convertEnum(en)).toList(growable: false);

  ModelEnum._(
    List<E> enumValues,
    E initial, [
    String fieldLabel,
  ])  : assert(enumValues.isNotEmpty, "Provide an enum list using the static .values getter method on the enum class."),
        assert(initial != null, "An initial enum instance must be provided"),
        _current = initial,
        _enums = enumValues,
        super.initial(convertEnum(initial),
            (String toValidate) => convertEnumList(enumValues).any((enStr) => enStr == toValidate), fieldLabel);

  /// Constructs a [ModelType] of an enum class,
  /// with the value being the [String] representation of the current enum instance.
  ///
  /// [enumValues] should come from calling the static `.values` getter on the enum class.
  ///
  /// [initial] must not be null and is the initial enum value held by this model.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelEnum(
    List<E> enumValues,
    E initial, [
    String fieldLabel,
  ]) =>
      ModelEnum._(enumValues, initial, fieldLabel);

  ModelEnum._next(ModelEnum<E> last, this._current)
      : _enums = last._enums,
        super.fromPrevious(last);

  @override
  ModelEnum<E> buildNext(String nextEnumString) =>
      ModelEnum._next(this, _enums.firstWhere((en) => nextEnumString == convertEnum(en)));

  // public methods

  @override
  String get value => convertEnum(_current);

  /// The current enum instance.
  E get valueAsEnum => _current;

  /// The list of all enums in the class as Strings
  /// (converted using [convertEnumList]).
  List<String> get enumStrings => convertEnumList(_enums);

  /// The list of all enums in the class.
  List<E> get enums => _enums;

  @override
  dynamic asSerializable() => value;

  @override
  String fromSerialized(dynamic jsonValue) =>
      jsonValue is String ? enumStrings.firstWhere((enStr) => enStr == jsonValue, orElse: () => null) : null;

  @override
  String toString() => "<$E>($value)";
}
