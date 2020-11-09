part of 'model_list.dart';

class ModelIntList extends ModelList<ModelIntList, int> {
  /// Constructs a [ModelType] of a list of [int]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialValue] defines the first (or default) list.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [int] list item passed to it is valid
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
  factory ModelIntList(
    List<int> initialValue, {
    ListItemValidator<int> itemValidator,
    String fieldLabel,
  }) =>
      ModelIntList._(initialValue, itemValidator, fieldLabel);

  ModelIntList._(
    List<int> initialList, [
    ListItemValidator<int> listItemValidator,
    String fieldLabel,
  ]) : super._(initialList, listItemValidator, fieldLabel);

  ModelIntList._next(ModelIntList previous, BuiltList<int> nextList)
      : super._constructNext(previous, nextList);

  @override
  ModelIntList buildNextInternal(BuiltList<int> next) =>
      ModelIntList._next(this, next);

  @override
  List<int> asSerializable() => super.asSerializable();
}
