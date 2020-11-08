import '../errors.dart';
import '../model_type.dart';

/// A model for an enum.
class ModelEnum<E> extends ModelType<ModelEnum<E>, E> {
  final E _current;
  final List<E> _enums;

  /// Constructs a [ModelType] of an enum class,
  /// with the value being the [String] representation of the current enum instance.
  ///
  /// [enumValues] should come from calling the static `.values` getter on the enum class.
  ///
  /// [initialValue] must not be null and is the initial enum value held by this model.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelEnum(
    List<E> enumValues,
    E initialValue, {
    String fieldLabel,
  }) {
    if (enumValues == null || enumValues.isEmpty) {
      throw ModelInitializationError(
        ModelEnum,
        "The enum values list must be provided. Use the static .values getter method on the enum class.",
      );
    }
    if (initialValue == null) {
      throw ModelInitializationError(
        ModelEnum,
        "An initial enum instance must be provided.",
      );
    }
    // can happen if E is dynamic, i.e. not set
    if (initialValue is! E) {
      throw ModelInitializationError(
        ModelEnum,
        "The enum type <E> must be set.",
      );
    }
    // weak check of E being an enum type
    try {
      enumValues.map(convertEnum);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ModelInitializationError(
        ModelEnum,
        "The E must be an enum type.",
      );
    }
    return ModelEnum._(enumValues, initialValue, fieldLabel);
  }

  ModelEnum._(
    this._enums,
    this._current, [
    String fieldLabel,
  ]) : super.initial(
          _current,
          (e) => _enums.contains(e),
          fieldLabel,
        );

  ModelEnum._next(ModelEnum<E> previous, this._current)
      : _enums = previous._enums,
        super.fromPrevious(previous);

  /// Returns [enumValue] as a [String].
  ///
  /// Only the name of the enum instance is returned, the class's name is stripped out.
  static String convertEnum<E>(E enumValue) =>
      enumValue.toString().split('.')[1];

  /// Converts [enumValues] to a list of Strings.
  ///
  /// [enumValues] should come from calling the static `.values` getter on the enum class.
  static List<String> convertEnumList<E>(List<E> enumValues) =>
      List.unmodifiable(enumValues.map(ModelEnum.convertEnum));

  /// Returns the enum in [enumValues] corresponding to [enumString],
  /// else returns `null`.
  static E fromString<E>(List<E> enumValues, String enumString) =>
      enumValues.firstWhere(
        (en) => enumString == ModelEnum.convertEnum<E>(en),
        orElse: () => null,
      );

  /// Returns each string in [enumStrings] converted
  /// to the corresponding enum in [enumValues],
  /// using the [fromString] function.
  ///
  /// `null` is returned if a single string has no corresponding enum value.
  static List<E> fromStringList<E>(
    List<E> enumValues,
    List<String> enumStrings,
  ) {
    final l =
        enumStrings.map((enStr) => ModelEnum.fromString<E>(enumValues, enStr));
    return l.contains(null) ? null : List.unmodifiable(l);
  }

  @override
  ModelEnum<E> buildNext(E nextEnum) => ModelEnum<E>._next(
        this,
        nextEnum,
      );

  ModelEnum<E> nextWithString(String nextString) {
    final en = ModelEnum.fromString<E>(_enums, nextString);
    return en != null
        ? next(en)
        : throw ModelEnumError(
            nextString,
            enumStrings,
          );
  }

  // can do this because E should be an enum type, thus it is immutable
  @override
  E get value => _current;

  /// The current enum instance as a String.
  String asString() => ModelEnum.convertEnum<E>(_current);

  /// The list of the possible enum values.
  List<E> get enums => List.unmodifiable(_enums);

  /// The list of all enums in the class as Strings
  /// (converted using [convertEnumList]).
  List<String> get enumStrings => ModelEnum.convertEnumList<E>(_enums);

  @override
  String asSerializable() => asString();

  @override
  E deserialize(dynamic jsonValue) =>
      jsonValue is String ? ModelEnum.fromString<E>(_enums, jsonValue) : null;

  @override
  String toString() => "ModelEnum<$E>($value)";
}
