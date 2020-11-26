import 'package:built_collection/built_collection.dart';

import '../../typedefs.dart';
import '../model_list.dart';

/// A model for a validated list of doubles.
class ModelDoubleList extends ModelList<ModelDoubleList, double> {
  /// Constructs a [ModelType] of a list of [double]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initialList] instance, useful when resetting.
  ///
  /// [listItemValidator] is a function that must return `true` if the [double] list item passed to it is valid
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
  factory ModelDoubleList([
    List<double> initialList = const <double>[],
    ModelListItemValidator<double> itemValidator,
  ]) =>
      ModelDoubleList._(initialList, itemValidator);

  ModelDoubleList._(
    List<double> initialList,
    ModelListItemValidator<double> listItemValidator,
  ) : super(initialList, listItemValidator);

  ModelDoubleList._next(ModelDoubleList previous, BuiltList<double> nextList)
      : super.constructNext(previous, nextList);

  @override
  ModelDoubleList buildNextInternal(BuiltList<double> next) =>
      ModelDoubleList._next(this, next);

  @override
  List<double> asSerializable() => super.asSerializable();
}
