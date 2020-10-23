import 'package:collection/collection.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../errors.dart';
import '../exceptions.dart';
import '../model_type.dart';
import '../utils/log.dart';
import 'model_inner.dart';

/// A function that validates an item from a list
typedef ListItemValidator<V> = bool Function(V listItem);

// todo: impl sorting
// todo: make modellist work publicly -> because of BuiltList it might work for any type?

/// An abstract class for a model for a validated list of items.
abstract class ModelList<M extends ModelList<M, T>, T>
    extends ModelType<M, List<T>> {
  final BuiltList<T> _current;

  ModelList._([
    List<T> initialList,
    ListItemValidator<T> listItemValidator,
    String fieldLabel,
  ])  : _current = BuiltList<T>.of(initialList ?? <T>[]),
        super.initial(
          initialList,
          listItemValidator == null
              ? null
              : (toValidate) =>
                  toValidate.every((listItem) => listItemValidator(listItem)),
          fieldLabel,
        );

  ModelList._constructNext(M previous, this._current)
      : super.fromPrevious(previous);

  @protected
  M _buildNextInternal(BuiltList<T> next);

  @override
  M buildNext(List<T> next) => _buildNextInternal(
        _current.rebuild((lb) => lb.replace(next)),
      );

  /// Checks if [next] is element-wise equal to the current list
  @override
  bool shouldBuild(List<T> next) => !(const ListEquality().equals(value, next));

  // public methods

  /// The underlying list of values.
  ///
  /// Note: this list is unmodifiable (i.e. read-only)
  @override
  List<T> get value => _current.asList();

  /// The underlying list of values.
  ///
  /// Note: this list is copy-on-write protected.
  /// When modified, a new instance will be created.
  List<T> get list => _current.toList();

  @override
  List asSerializable() => value;

  @override
  List<T> fromSerialized(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        return serialized.cast<T>().toList();
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Append the items in [list] to the end of the current underlying list.
  ///
  /// If [list] does not [validate], a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
  /// and the current instance returned with no update applied.
  M append(List<T> list) => validate(list)
      ? _buildNextInternal(_current.rebuild((lb) => lb.addAll(list)))
      : logExceptionAndReturn(this, ValidationException(M, list, fieldLabel));

  /// Replaces the item at [index] with [item].
  ///
  /// If [item] does not [validate], a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
  /// and the current instance returned with no update applied.
  M replaceAt(int index, T Function(T current) updater) {
    final update = updater(this[index]);
    return validate([update])
        ? _buildNextInternal(_current.rebuild((lb) => lb[index] = update))
        : logExceptionAndReturn(
            this,
            ValidationException(M, update, fieldLabel),
          );
  }

  /// Removes the item at [index], reducing [numberOfItems] by 1.
  M removeAt(int index) =>
      _buildNextInternal(_current.rebuild((lb) => lb.removeAt(index)));

  /// Removes all elements from this list.
  ///
  /// As [List.clear].
  M clear() => _buildNextInternal(_current.rebuild((lb) => lb.clear()));

  /// Returns the item at [index].
  T getElementAt(int index) => _current.elementAt(index);

  /// Returns the item at [index].
  T operator [](int index) => getElementAt(index);

  /// Returns the number of items in the list
  int get numberOfItems => _current.length;

  @override
  List<Object> get props => [_current];
}

class ModelBoolList extends ModelList<ModelBoolList, bool> {
  ModelBoolList._([
    List<bool> initialList,
    String fieldLabel,
  ]) : super._(initialList, null, fieldLabel);

  ModelBoolList._next(ModelBoolList previous, BuiltList<bool> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [bool]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initial] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelBoolList({
    List<bool> initial,
    String fieldLabel,
  }) =>
      ModelBoolList._(initial, fieldLabel);

  @override
  ModelBoolList _buildNextInternal(BuiltList<bool> next) =>
      ModelBoolList._next(this, next);
}

class ModelIntList extends ModelList<ModelIntList, int> {
  ModelIntList._([
    List<int> initialList,
    ListItemValidator<int> listItemValidator,
    String fieldLabel,
  ]) : super._(initialList, listItemValidator, fieldLabel);

  ModelIntList._next(ModelIntList previous, BuiltList<int> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [int]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initial] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [int] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initial] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initial].
  factory ModelIntList({
    List<int> initial,
    ListItemValidator<int> itemValidator,
    String fieldLabel,
  }) =>
      ModelIntList._(initial, itemValidator, fieldLabel);

  @override
  ModelIntList _buildNextInternal(BuiltList<int> next) =>
      ModelIntList._next(this, next);
}

/// A model for a validated list of doubles.
class ModelDoubleList extends ModelList<ModelDoubleList, double> {
  ModelDoubleList._([
    List<double> initialList,
    ListItemValidator<double> listItemValidator,
    String fieldLabel,
  ]) : super._(initialList, listItemValidator, fieldLabel);

  ModelDoubleList._next(ModelDoubleList previous, BuiltList<double> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [double]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initial] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [double] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initial] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initial].
  factory ModelDoubleList({
    List<double> initial,
    ListItemValidator<double> itemValidator,
    String fieldLabel,
  }) =>
      ModelDoubleList._(initial, itemValidator, fieldLabel);

  @override
  ModelDoubleList _buildNextInternal(BuiltList<double> next) =>
      ModelDoubleList._next(this, next);
}

/// A model for a validated list of Strings.
class ModelStringList extends ModelList<ModelStringList, String> {
  ModelStringList._([
    List<String> initialList,
    ListItemValidator<String> listItemValidator,
    String fieldLabel,
  ]) : super._(initialList, listItemValidator, fieldLabel);

  ModelStringList._next(ModelStringList previous, BuiltList<String> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [String]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initial] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [String] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initial] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initial].
  factory ModelStringList({
    List<String> initial,
    ListItemValidator<String> itemValidator,
    String fieldLabel,
  }) =>
      ModelStringList._(initial, itemValidator, fieldLabel);

  @override
  ModelStringList _buildNextInternal(BuiltList<String> next) =>
      ModelStringList._next(this, next);
}

/// A model for a validated list of DateTimes.
class ModelDateTimeList extends ModelList<ModelDateTimeList, DateTime> {
  ModelDateTimeList._([
    List<DateTime> initial,
    ListItemValidator<DateTime> listItemValidator,
    String fieldLabel,
  ]) : super._(initial, listItemValidator, fieldLabel);

  ModelDateTimeList._next(
      ModelDateTimeList previous, BuiltList<DateTime> nextList)
      : super._constructNext(previous, nextList);

  /// Constructs a [ModelType] of a list of [DateTime]s.
  ///
  /// Updates (i.e. a call to [next]) are appended to the end of the list.
  ///
  /// [initial] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [DateTime] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initial] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [listItemValidator] returns `false` on an element of [initial].
  factory ModelDateTimeList({
    List<DateTime> initial,
    ListItemValidator<DateTime> itemValidator,
    String fieldLabel,
  }) =>
      ModelDateTimeList._(initial, itemValidator, fieldLabel);

  @override
  ModelDateTimeList _buildNextInternal(BuiltList<DateTime> next) =>
      ModelDateTimeList._next(this, next);

  @override
  List<String> asSerializable() =>
      value.map((dt) => dt.toIso8601String()).toList(growable: false);

  @override
  List<DateTime> fromSerialized(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        return serialized.cast<String>().map(DateTime.parse).toList();
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }
}

// /// A model for a list of Maps validated against a model.
// class ModelValidatedList
//     extends _ModelList<ModelValidatedList, Map<String, dynamic>> {
//   ModelValidatedList._([
//     List<Map<String, dynamic>> initialList,
//     ListItemValidator<Map<String, dynamic>> listItemValidator,
//     bool append = true,
//     String fieldLabel,
//   ]) : super._(initialList, listItemValidator, append, fieldLabel);

//   ModelValidatedList._next(
//       ModelValidatedList previous, BuiltList<Map<String, dynamic>> nextList)
//       : super._constructNext(previous, nextList);

//   /// Constructs a [ModelType] of a list of [Map]s that are validated against a [ModelInner].
//   ///
//   /// [initialList] defines the first (or default) list.
//   /// This can be accessed using the [initial] instance, useful when resetting.
//   /// [initialList] can be `null` indicating this model has no initial (or default) value.
//   ///
//   /// If [ModelInner.strictUpdates] is set `true` for [model],
//   /// every map in the underlying list must contain all fields defined in [model],
//   /// otherwise they can contain a sub-set of the fields.
//   /// All map values will be validated against [model] too.
//   ///
//   /// If the list is updated with a map that does not validate (using [ModelInner.checkUpdate]),
//   /// a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
//   /// and the current instance returned (without the updated applied).
//   ///
//   /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
//   /// If `false`, the list passed into the updating function will replace the current list.
//   ///
//   /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
//   /// This is not guaranteed, however.
//   ///
//   /// [initialList] will be validated against the model if it is not null.
//   ///
//   /// Throws a [ModelInitializationError] if [model] is `null`.
//   /// Throws a [ModelInitialValidationError] if [initialList] contains an invalid map.
//   factory ModelValidatedList(
//     ModelInner model, {
//     List<Map<String, dynamic>> initialList,
//     bool append = true,
//     String fieldLabel,
//   }) {
//     if (model == null) {
//       throw ModelInitializationError(
//           ModelValidatedList, "A model must be provided");
//     }
//     return ModelValidatedList._(initialList,
//         (mapItem) => model.checkUpdate(mapItem), append, fieldLabel);
//   }

//   @override
//   ModelValidatedList _buildNextInternal(BuiltList<Map<String, dynamic>> next) =>
//       ModelValidatedList._next(this, next);
// }
