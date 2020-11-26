import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../exceptions.dart';
import '../model_type.dart';
import '../typedefs.dart';
import '../utils/loggers.dart';

/// An abstract class for a model for a validated list of items.
/// This class is meant to be extended inside this library only.
abstract class ModelList<M extends ModelList<M, T>, T>
    extends ModelType<M, List<T>> {
  /// The current underlying immutable list
  final BuiltList<T> _current;

  ModelList(
    List<T> initialList,
    ModelListItemValidator<T> listItemValidator,
  )   : _current = BuiltList<T>.of(initialList ?? <T>[]),
        super.initial(
            initialList,
            listItemValidator == null
                ? null
                : (toValidate) => toValidate
                    .every((listItem) => listItemValidator(listItem)));

  ModelList.constructNext(M previous, this._current)
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
          this,
          ModelValidationException(M, list),
        );

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
            ModelValidationException(M, update),
          );
  }

  /// Removes the item at [index], reducing [numberOfItems] by 1.
  ///
  /// As [List.removeAt]
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

  /// Returns the first element.
  ///
  /// Throws a [StateError] if this is empty. Otherwise returns the first element in the iteration order, equivalent to this.elementAt(0).
  ///
  /// Copied from [Iterable].
  T get first => _current.first;

  ///Returns the last element.
  ///
  /// Throws a [StateError] if this is empty.
  /// Otherwise may iterate through the elements and
  /// returns the last one seen. Some iterables may have more
  /// efficient ways to find the last element (for example a list can directly access the last element, without iterating through the previous ones).
  ///
  /// Copied from Iterable.
  T get last => _current.last;

  @override
  List<Object> get props => [_current];
}
