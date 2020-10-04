import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../model_type.dart';
import '../utils/log.dart';
import 'model_inner.dart';

/// A function that validates an item from a list
typedef ListItemValidator<V> = bool Function(V list);

/// A model for a validated list of items.
class ModelList<T> extends ModelType<ModelList<T>, List<T>> {
  final BuiltList<T> _current;
  final bool _append;

  // constructors

  ModelList._([
    List<T> initialList,
    ListItemValidator<T> listItemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<T>.of(initialList ?? <T>[]),
        _append = append,
        super.initial(
          initialList,
          listItemValidator == null
              ? null
              : (toValidate) =>
                  toValidate.every((listItem) => listItemValidator(listItem)),
          fieldLabel,
        );

  /// Constructs a [ModelType] of a list of [bool]s.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelList.boolList({
    List<bool> initialList,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList._(initialList as List<T>, null, append, fieldLabel);

  /// Constructs a [ModelType] of a list of [int]s.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [int] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initialList] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [listItemValidator] returns `false` on an element of [initialList].
  factory ModelList.intList({
    List<int> initialList,
    ListItemValidator<int> listItemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList._(initialList as List<T>,
          listItemValidator as ListItemValidator<T>, append, fieldLabel);

  /// Constructs a [ModelType] of a list of [double]s.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [double] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initialList] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [listItemValidator] returns `false` on an element of [initialList].
  factory ModelList.doubleList({
    List<double> initialList,
    ListItemValidator<double> listItemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList._(initialList as List<T>,
          listItemValidator as ListItemValidator<T>, append, fieldLabel);

  /// Constructs a [ModelType] of a list of [String]s.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [String] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initialList] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [listItemValidator] returns `false` on an element of [initialList].
  factory ModelList.stringList({
    List<String> initialList,
    ListItemValidator<String> listItemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList._(initialList as List<T>,
          listItemValidator as ListItemValidator<T>, append, fieldLabel);

  /// Constructs a [ModelType] of a list of [DateTime]s.
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [listItemValidator] is a function that must return `true` if the [DateTime] list item passed to it is valid
  /// and `false` otherwise. [listItemValidator] can be `null` indicating this model has no validation.
  ///
  /// [listItemValidator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true` on every list element, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [listItemValidator] will be run on the elements of [initialList] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [listItemValidator] returns `false` on an element of [initialList].
  factory ModelList.dateTimeList({
    List<DateTime> initialList,
    ListItemValidator<DateTime> listItemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList._(initialList as List<T>,
          listItemValidator as ListItemValidator<T>, append, fieldLabel);

  /// Constructs a [ModelType] of a list of [Map]s that are validated against a [ModelInner].
  ///
  /// [initialList] defines the first (or default) list.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialList] can be `null` indicating this model has no initial (or default) value.
  ///
  /// If [ModelInner.strictUpdates] is set `true` for [model],
  /// every map in the underlying list must contain all fields defined in [model],
  /// otherwise they can contain a sub-set of the fields.
  /// All map values will be validated against [model] too.
  ///
  /// If the list is updated with a map that does not validate (using [ModelInner.checkUpdate]),
  /// a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
  /// and the current instance returned (without the updated applied).
  ///
  /// If [append] is `true`, updates (using [next] etc.) will be appended to the end of the current list.
  /// If `false`, the list passed into the updating function will replace the current list.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [initialList] will be validated against the model if it is not null.
  ///
  /// Throws a [ModelInitializationError] if [initialList] contains an invalid map.
  factory ModelList.modelValidatedList(
    ModelInner model, {
    List<Map<String, dynamic>> initialList,
    bool append = true,
    String fieldLabel,
  }) {
    assert(model != null, "A model must be provided");
    return ModelList._(
        initialList as List<T>,
        (mapItem) => model.checkUpdate(mapItem as Map<String, dynamic>),
        append,
        fieldLabel);
  }

  ModelList._next(ModelList<T> last, this._current)
      : _append = last._append,
        super.fromPrevious(last);

  @override
  ModelList<T> buildNext(List<T> next) => ModelList._next(this,
      _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  // public methods

  @override
  List<T> get value => _current.toList();

  @override
  dynamic asSerializable() => T == DateTime
      ? (value.map((dt) => (dt as DateTime).toIso8601String()))
      : value;

  @override
  List<T> fromSerialized(dynamic serialized) => serialized is List
      ? T == DateTime
          ? serialized.cast<String>().map(DateTime.parse) as List<T>
          : serialized.cast<T>()
      : null;

  /// Removes the value at [index], reducing [numberOfItems] by 1.
  ModelList<T> removeAt(int index) =>
      ModelList._next(this, _current.rebuild((lb) => lb.removeAt(index)));

  /// Replaces the value at [index] with [item].
  ///
  /// If item does not [validate], a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
  /// and the value will not be replaced.
  ModelList<T> replaceAt(int index, T item) =>
      ModelList._next(this, _current.rebuild((lb) {
        if (validate([item])) {
          lb[index] = item;
        } else {
          logException(ValidationException(this, item));
        }
      }));

  /// Removes all objects from this list.
  ///
  /// As [List.clear].
  ModelList<T> clear() =>
      ModelList._next(this, _current.rebuild((lb) => lb.clear()));

  /// Returns the value at [index].
  T getElementAt(int index) => _current.elementAt(index);

  /// Returns the value at [index].
  T operator [](int index) => getElementAt(index);

  /// Returns the number of items in the list
  int get numberOfItems => _current.length;

  @override
  List<Object> get props => [_current];
}
