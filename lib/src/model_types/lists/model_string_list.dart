import 'package:built_collection/built_collection.dart';

import '../../typedefs.dart';
import '../model_list.dart';

/// A model for a validated list of Strings.
class ModelStringList extends ModelList<ModelStringList, String> {
  /// Constructs a [ModelType] of a list of [String]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initialList] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [String] list item passed to it is valid
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
  factory ModelStringList([
    List<String> initialList = const <String>[],
    ListItemValidator<String> itemValidator,
  ]) =>
      ModelStringList._(initialList, itemValidator);

  ModelStringList._(
    List<String> initialList,
    ListItemValidator<String> listItemValidator,
  ) : super(initialList, listItemValidator);

  ModelStringList._next(ModelStringList previous, BuiltList<String> nextList)
      : super.constructNext(previous, nextList);

  @override
  ModelStringList buildNextInternal(BuiltList<String> next) =>
      ModelStringList._next(this, next);

  @override
  List<String> asSerializable() => super.asSerializable();
}
