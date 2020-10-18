import '../errors.dart';
import '../model_type.dart';

/// A model for an enum.
class ModelEnum<E> extends ModelType<ModelEnum<E>, E> {
  final E _current;
  final List<E> _enums;

  /// Returns [enumValue] as a [String].
  ///
  /// Only the name of the enum instance is returned, the class's name is stripped out.
  static String convertEnum<E>(E enumValue) =>
      enumValue.toString().split('.')[1];

  /// Converts [enumValues] to a list of Strings.
  ///
  /// [enumValues] should come from calling the static `.values` getter on the enum class.
  static List<String> convertEnumList<E>(List<E> enumValues) =>
      enumValues.map(convertEnum).toList(growable: false);

  ModelEnum._(
    List<E> enumValues,
    E initial, [
    String fieldLabel,
  ])  : _current = initial,
        _enums = enumValues,
        super.initial(
          initial,
          null, // updates have to be of type E, so they're auto valid
          fieldLabel,
        );

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
    E initial, {
    String fieldLabel,
  }) {
    if (enumValues.isEmpty) {
      throw ModelInitializationError(
        ModelEnum,
        "The enum values list must be provided. Use the static .values getter method on the enum class.",
      );
    }
    if (initial == null) {
      throw ModelInitializationError(
        ModelEnum,
        "An initial enum instance must be provided",
      );
    }
    return ModelEnum._(enumValues, initial, fieldLabel);
  }

  ModelEnum._next(ModelEnum<E> last, this._current)
      : _enums = last._enums,
        super.fromPrevious(last);

  @override
  ModelEnum<E> buildNext(E nextEnum) => ModelEnum._next(
        this,
        nextEnum,
      );

  ModelEnum<E> nextFromString(String nextEnumString) {
    final en = fromString(nextEnumString);
    return en != null ? next(en) : throw ModelEnumError(this, nextEnumString);
  }

  // public methods

  @override
  E get value => _current;

  /// Returns the enum corresponding to [enumString].
  ///
  /// If [enumString] is not one of the enums held,
  /// `null` is returned.
  E fromString(String enumString) => _enums.firstWhere(
        (en) => enumString == convertEnum(en),
        orElse: () => null,
      );

  /// The current enum instance as a String.
  String get asString => convertEnum(_current);

  /// The list of all enums in the class.
  List<E> get enums => _enums;

  /// The list of all enums in the class as Strings
  /// (converted using [convertEnumList]).
  List<String> get enumStrings => convertEnumList(_enums);

  @override
  dynamic asSerializable() => asString;

  @override
  E fromSerialized(dynamic jsonValue) =>
      jsonValue is String ? fromString(jsonValue) : null;

  @override
  String toString() => "<ModelEnum<$E>>($value)";
}
