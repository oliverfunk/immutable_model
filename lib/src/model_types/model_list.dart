import 'package:built_collection/built_collection.dart';

import '../utils/log.dart';
import '../exceptions.dart';

import '../model_type.dart';
import 'model_inner.dart';

/// A function that validates an item from a list
typedef bool ListItemValidator<V>(V list);

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
              : (List<T> toValidate) => toValidate.every((listItem) => listItemValidator(listItem)),
          fieldLabel,
        );

  factory ModelList.boolList([
    List<bool> initialList,
    bool append = true,
    String fieldLabel,
  ]) =>
      ModelList._(initialList as List<T>, null, append, fieldLabel) as ModelList<bool>;

  factory ModelList.intList([
    List<int> initialList,
    ListItemValidator<int> listItemValidator,
    bool append = true,
    String fieldLabel,
  ]) =>
      ModelList._(initialList as List<T>, listItemValidator as ListItemValidator<T>, append, fieldLabel);

  factory ModelList.doubleList([
    List<double> initialList,
    ListItemValidator<double> listItemValidator,
    bool append = true,
    String fieldLabel,
  ]) =>
      ModelList._(initialList as List<T>, listItemValidator as ListItemValidator<T>, append, fieldLabel);

  factory ModelList.stringList([
    List<String> initialList,
    ListItemValidator<String> listItemValidator,
    bool append = true,
    String fieldLabel,
  ]) =>
      ModelList._(initialList as List<T>, listItemValidator as ListItemValidator<T>, append, fieldLabel);

  factory ModelList.dateTimeList([
    List<DateTime> initialList,
    ListItemValidator<DateTime> listItemValidator,
    bool append = true,
    String fieldLabel,
  ]) =>
      ModelList._(initialList as List<T>, listItemValidator as ListItemValidator<T>, append, fieldLabel);

  ModelList._next(ModelList<T> last, this._current)
      : _append = last._append,
        super.fromPrevious(last);

  @override
  ModelList<T> buildNext(List<T> next) =>
      ModelList._next(this, _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  // public methods

  @override
  List<T> get value => _current.toList();

  @override
  dynamic asSerializable() => T == DateTime ? (value.map((dt) => (dt as DateTime).toIso8601String())) : value;

  @override
  List<T> fromSerialized(dynamic serialized) => serialized is List
      ? T == DateTime
          ? serialized.cast<String>().map((dtStr) => DateTime.parse(dtStr)) as List<T>
          : serialized.cast<T>()
      : null;

  /// Removes the value at [index], reducing [numberOfItems] by 1.
  ModelList<T> removeAt(int index) => ModelList._next(this, _current.rebuild((lb) => lb.removeAt(index)));

  /// Replaces the value at [index] with [item].
  ///
  /// If item does not [validate], a [ValidationException] will be logged as a *WARNING* message (instead of being thrown)
  /// and the value will not be replaced.
  ModelList<T> replaceAt(int index, T item) => ModelList._next(this, _current.rebuild((lb) {
        if (validate([item])) {
          lb[index] = item;
        } else {
          logException(ValidationException(this, item));
        }
      }));

  /// Removes all objects from this list.
  ///
  /// As [List.clear].
  ModelList<T> clear() => ModelList._next(this, _current.rebuild((lb) => lb.clear()));

  /// Returns the value at [index].
  T getElementAt(int index) => _current.elementAt(index);

  /// Returns the value at [index].
  T operator [](int index) => getElementAt(index);

  /// Returns the number of items in the list
  int get numberOfItems => _current.length;

  @override
  List<Object> get props => [_current];
}

/// A model for a list of [Map]s that are validated against a defined [ModelInner] [model].
///
/// If [ModelInner.strictUpdates] is set `true`, every map in this list must have all the fields defined in the [model]
/// and the value must all be valid.
class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(
    ModelInner model, [
    List<Map<String, dynamic>> initialList,
    bool append = true,
    String fieldLabel,
  ]) : super._(initialList, (mapItem) => _validateAgainstModel(model, mapItem), append, fieldLabel);

  static bool _validateAgainstModel(ModelInner model, Map<String, dynamic> update) => model.checkUpdate(update);
}
