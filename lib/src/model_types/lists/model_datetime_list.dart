part of 'model_list.dart';

/// A model for a validated list of DateTimes.
class ModelDateTimeList extends ModelList<ModelDateTimeList, DateTime> {
  /// Constructs a [ModelType] of a list of [DateTime]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialValue] defines the first (or default) list.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [DateTime] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ModelValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initialValue].
  factory ModelDateTimeList(
    List<DateTime> initialValue, {
    ListItemValidator<DateTime> itemValidator,
    String fieldLabel,
  }) =>
      ModelDateTimeList._(initialValue, itemValidator, fieldLabel);
  ModelDateTimeList._(
    List<DateTime> initialList, [
    ListItemValidator<DateTime> listItemValidator,
    String fieldLabel,
  ]) : super._(initialList, listItemValidator, fieldLabel);

  ModelDateTimeList._next(
      ModelDateTimeList previous, BuiltList<DateTime> nextList)
      : super._constructNext(previous, nextList);

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
