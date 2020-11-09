part of 'model_list.dart';

class ModelEnumList<E> extends ModelList<ModelEnumList<E>, E> {
  final List<E> _enums;

  /// A list of enums
  factory ModelEnumList(
    List<E> enumValues,
    List<E> initialValue, {
    String fieldLabel,
  }) {
    if (enumValues == null || enumValues.isEmpty) {
      throw ModelInitializationError(
        ModelEnum,
        "The enum values list must be provided. Use the static .values getter method on the enum class.",
      );
    }
    // can happen if E is dynamic, i.e. not set
    if (initialValue is! List<E>) {
      throw ModelInitializationError(
        ModelEnum,
        "The enum type <E> must be set",
      );
    }
    // weak check of E being an enum type
    try {
      enumValues.map(ModelEnum.convertEnum);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ModelInitializationError(
        ModelEnum,
        "The E must be an enum type.",
      );
    }
    return ModelEnumList._(enumValues, initialValue, fieldLabel);
  }

  ModelEnumList._(
    this._enums,
    List<E> initialList, [
    String fieldLabel,
  ]) : super._(
          initialList,
          (e) => _enums.contains(e),
          fieldLabel,
        );

  ModelEnumList._next(ModelEnumList previous, BuiltList<E> nextList)
      : _enums = previous._enums,
        super._constructNext(previous, nextList);

  @override
  ModelEnumList<E> buildNextInternal(BuiltList<E> next) =>
      ModelEnumList<E>._next(this, next);

  ModelEnumList<E> nextWithStrings(List<String> nextStrings) {
    final ens = ModelEnum.fromStringList<E>(_enums, nextStrings);
    return ens != null
        ? next(ens)
        : throw ModelEnumError(
            nextStrings,
            enumStrings,
          );
  }

  /// The current enum instance as a String.
  List<String> asStringList() => ModelEnum.convertEnumList<E>(value);

  /// The list of the possible enum values.
  List<E> get enums => List.unmodifiable(_enums);

  /// The list of the possible enum values as Strings
  /// (converted using [convertEnumList]).
  List<String> get enumStrings => ModelEnum.convertEnumList<E>(_enums);

  @override
  List<String> asSerializable() => asStringList();

  @override
  List<E> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        // will return null if a string does not match one of the enums
        return ModelEnum.fromStringList<E>(_enums, serialized.cast<String>());
        // ignore: avoid_catching_errors
      } on TypeError {
        // cast failed
        return null;
      }
    } else {
      return null;
    }
  }
}
