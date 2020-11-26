import 'package:built_collection/built_collection.dart';

import '../../typedefs.dart';
import '../model_list.dart';

/// A model for a validated list of DateTimes.
class ModelDateTimeList extends ModelList<ModelDateTimeList, DateTime> {
  /// Constructs a [ModelType] of a list of [DateTime]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initialList] instance, useful when resetting.
  ///
  /// [listItemValidator] is a function that must return `true` if the [DateTime] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ModelValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [listItemValidator] will be run on the elements of [initialList] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initialList].
  factory ModelDateTimeList([
    List<DateTime> initialList = const <DateTime>[],
    ModelListItemValidator<DateTime> itemValidator,
  ]) =>
      ModelDateTimeList._(initialList, itemValidator);

  ModelDateTimeList._(
    List<DateTime> initialList,
    ModelListItemValidator<DateTime> listItemValidator,
  ) : super(initialList, listItemValidator);

  ModelDateTimeList._next(
      ModelDateTimeList previous, BuiltList<DateTime> nextList)
      : super.constructNext(previous, nextList);

  @override
  ModelDateTimeList buildNextInternal(BuiltList<DateTime> next) =>
      ModelDateTimeList._next(this, next);

  @override
  List<String> asSerializable() =>
      List.unmodifiable(value.map((i) => i.toIso8601String()));

  @override
  List<DateTime> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        return serialized.cast<String>().map(DateTime.parse).toList();
        // ignore: avoid_catching_errors
      } on TypeError {
        // cast failed
        return null;
      } on FormatException {
        // parse failed
        return null;
      }
    } else {
      return null;
    }
  }
}
