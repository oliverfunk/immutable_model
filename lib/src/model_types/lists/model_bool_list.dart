part of 'model_list.dart';

class ModelBoolList extends ModelList<ModelBoolList, bool> {
  ModelBoolList._(
    List<bool> initialList, [
    String fieldLabel,
  ]) : super._(initialList, null, fieldLabel);

  ModelBoolList._next(ModelBoolList previous, BuiltList<bool> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [bool]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialValue] defines the first (or default) list.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelBoolList(
    List<bool> initialValue, {
    String fieldLabel,
  }) =>
      ModelBoolList._(initialValue, fieldLabel);

  @override
  ModelBoolList buildNextInternal(BuiltList<bool> next) =>
      ModelBoolList._next(this, next);

  @override
  List<bool> asSerializable() => super.asSerializable();
}
