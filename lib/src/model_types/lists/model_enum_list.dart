import 'package:built_collection/built_collection.dart';

import '../../errors.dart';
import '../model_enum.dart';
import '../model_list.dart';

class ModelEnumList<E> extends ModelList<ModelEnumList<E>, E> {
  final List<E> _enums;

  /// A list of enums
  ///
  /// if [initialList] is omitted, an empty list <E>[] will be used.
  factory ModelEnumList(
    List<E> enumValues, [
    List<E> initialList,
  ]) {
    if (enumValues == null || enumValues.isEmpty) {
      throw ModelInitializationError(
        ModelEnumList,
        "The enum values list must be provided. Use the static .values getter method on the enum class.",
      );
    }
    if (E == dynamic) {
      throw ModelInitializationError(
        ModelEnumList,
        "<E> cannot be dynamic, it must be set explicitly.",
      );
    }
    // weak check of E being an enum type
    try {
      enumValues.map(ModelEnum.convertEnum);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ModelInitializationError(
        ModelEnumList,
        "<E> must be an enum type.",
      );
    }
    return ModelEnumList._(enumValues, initialList);
  }

  ModelEnumList._(
    this._enums,
    List<E> initialList,
  ) : super(initialList, (e) => _enums.contains(e));

  ModelEnumList._next(ModelEnumList previous, BuiltList<E> nextList)
      : _enums = previous._enums,
        super.constructNext(previous, nextList);

  @override
  ModelEnumList<E> buildNextInternal(BuiltList<E> next) =>
      ModelEnumList<E>._next(this, next);

  /// Returns a new instance using the strings in [nextStrings].
  ///
  /// These must correspond to the name of the enum values
  /// defined for [E].
  ///
  /// Throws a [ModelEnumError] if a string in [nextStrings]
  /// has no corresponding enum value.
  ModelEnumList<E> nextWithStrings(List<String> nextStrings) {
    final es = ModelEnum.fromStringList<E>(_enums, nextStrings);
    return es != null
        ? next(es)
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
