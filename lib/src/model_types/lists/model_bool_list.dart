import 'package:built_collection/built_collection.dart';

import '../model_list.dart';

class ModelBoolList extends ModelList<ModelBoolList, bool> {
  /// Constructs a [ModelType] of a list of [bool]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initialList] instance, useful when resetting.
  ///
  /// This model needs no validation.
  factory ModelBoolList([
    List<bool> initialList = const <bool>[],
  ]) =>
      ModelBoolList._(initialList);

  ModelBoolList._(
    List<bool> initialList,
  ) : super(initialList, null);

  ModelBoolList._next(ModelBoolList previous, BuiltList<bool> nextList)
      : super.constructNext(previous, nextList);

  @override
  ModelBoolList buildNextInternal(BuiltList<bool> next) =>
      ModelBoolList._next(this, next);

  @override
  List<bool> asSerializable() => super.asSerializable();
}
