import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../errors.dart';
import '../../exceptions.dart';
import '../../immutable_model.dart';
import '../../model_type.dart';
import '../../model_value.dart';
import '../../utils/log.dart';
import '../model_enum.dart';
import '../model_inner.dart';

part 'model_bool_list.dart';
part 'model_datetime_list.dart';
part 'model_double_list.dart';
part 'model_inner_list.dart';
part 'model_int_list.dart';
part 'model_string_list.dart';
part 'model_value_list.dart';
part 'model_enum_list.dart';

/// A function that validates an item from a list
typedef ListItemValidator<V> = bool Function(V listItem);

/// An abstract class for a model for a validated list of items.
/// This class is meant to be extended inside this library only.
abstract class ModelList<M extends ModelList<M, T>, T>
    extends ModelType<M, List<T>> {
  final BuiltList<T> _current;

  ModelList._(
    List<T> initialList, [
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

  @override
  M buildNext(List<T> next) => buildNextInternal(
        _current.rebuild((lb) => lb.replace(next)),
      );

  @protected
  M buildNextInternal(BuiltList<T> next);

  /// Checks if [next] is element-wise equal to the current list
  @override
  bool shouldBuild(List<T> next) => !(const ListEquality().equals(value, next));

  // public methods

  /// The underlying list of values.
  ///
  /// Note: this list is unmodifiable (i.e. read-only)
  @override
  List<T> get value => _current.asList();

  /// Returns a copy-on-write protected List instance of this model.
  ///
  /// When modified, a new instance will be created.
  List<T> asList() => _current.toList();

  @override
  List asSerializable() => value;

  @override
  List<T> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        return serialized.cast<T>().toList();
        // ignore: avoid_catching_errors
      } on TypeError {
        // cast failed
        return null;
      }
    } else {
      return null;
    }
  }

  /// Returns a new instance of this list
  /// sorted by the order specified by [comparator].
  ///
  /// As [List.sort].
  M sort(Comparator<T> comparator) =>
      buildNextInternal(_current.rebuild((lb) => lb..sort(comparator)));

  /// Append the items in [list] to the end of the current underlying list.
  ///
  /// If [list] does not [validate],
  /// a [ModelValidationException] will be logged as a *WARNING* message
  /// (instead of being thrown) and the current instance returned
  /// with no update applied.
  M append(List<T> list) => validate(list)
      ? buildNextInternal(_current.rebuild((lb) => lb.addAll(list)))
      : logExceptionAndReturn(
          this, ModelValidationException(M, list, fieldLabel));

  /// Replaces the item at [index] with the value returned by [updater].
  ///
  /// If the returned value does not [validate],
  /// a [ModelValidationException] will be logged as a *WARNING* message
  /// (instead of being thrown) and the current instance returned
  /// with no update applied.
  M replaceAt(int index, T updater(T current)) {
    final update = updater(itemAt(index));
    return validate([update])
        ? buildNextInternal(_current.rebuild((lb) => lb[index] = update))
        : logExceptionAndReturn(
            this,
            ModelValidationException(M, update, fieldLabel),
          );
  }

  /// Removes the item at [index], reducing [numberOfItems] by 1.
  M removeAt(int index) =>
      buildNextInternal(_current.rebuild((lb) => lb.removeAt(index)));

  /// Removes all elements from this list.
  ///
  /// As [List.clear].
  M clear() => buildNextInternal(_current.rebuild((lb) => lb.clear()));

  /// Returns the item at [index].
  T itemAt(int index) => _current.elementAt(index);

  /// Returns the item at [index].
  T operator [](int index) => itemAt(index);

  /// Returns the number of items in the list
  int get numberOfItems => _current.length;

  @override
  List<Object> get props => [_current];
}