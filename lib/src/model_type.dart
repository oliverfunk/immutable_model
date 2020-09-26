import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'utils/log.dart';
import 'errors.dart';
import 'exceptions.dart';

/// A function that validates the [value] passed to it.
typedef bool ValueValidator<V>(V value);

/// A function that updates the value of a model based on its [currentValue].
typedef dynamic ValueUpdater(dynamic currentValue);

/// An abstract base class that defines common model attributes and behaviors.
///
/// Any class that extends this must be immutable and will have equality based on its current [value],
/// as provided by [Equatable].
@immutable
abstract class ModelType<M extends ModelType<M, V>, V> extends Equatable {
  /// The model's current value.
  V get value;

  /// The initial instance of this model.
  ///
  /// Can be null.
  final M _initialModel;

  /// The initial instance of this model.
  ///
  /// Used when resetting a model and commonly to determine whether another model
  /// shares a common history with this one (via [hasEqualityOfHistory]).
  M get initial => _initialModel ?? this;

  /// True if this instance is the initial instance.
  @nonVirtual
  bool get isInitial => identical(this, initial);

  /// The field label associated with this model.
  ///
  /// Used in debugging or dynamically accessing this model via its field label.
  final String fieldLabel;

  /// The validator applied to updates to this model.
  final ValueValidator<V> _validator;

  /// Determines whether [toValidate] is valid or not.
  ///
  /// Returns `true` if it is.
  @nonVirtual
  bool validate(V toValidate) => _validator == null || _validator(toValidate);

  /// Constructor for the first instance of this [ModelType].
  ///
  /// If the supplied [initialValue] and [validator] are not null,
  /// [validator] will be run on the [initialValue].
  ///
  /// Throws a [ModelInitializationError] if [validator] returns false after being run on [initialValue].
  ModelType.initial(
    V initialValue,
    ValueValidator<V> validator,
    this.fieldLabel,
  )   : _validator = validator,
        _initialModel = null {
    if (initialValue != null && !validate(initialValue)) {
      logException(ValidationException(this, value));
      throw ModelInitializationError(this, value);
    }
  }

  /// A copy constructor.
  ///
  /// Used during a call to [next], in [buildNext], to construct the next model instance from a [previous] one.
  ModelType.fromPrevious(M previous)
      : _initialModel = previous.initial,
        _validator = previous._validator,
        fieldLabel = previous.fieldLabel;

  /// Returns a new instance of this model given [nextValue].
  ///
  /// Used to hook in the constructor of a sub-class.
  @protected
  M buildNext(V nextValue);

  /// Returns an new instance of this model if [nextValue] is valid.
  ///
  /// Logs a [ValidationException] as a *WARNING* message (instead of throwing it) if [nextValue] is not valid
  /// and returns the current instance.
  @nonVirtual
  M next(V nextValue) => nextValue == null
      ? this
      : validate(nextValue)
          ? buildNext(nextValue)
          : logExceptionAndReturn(this, ValidationException(this, nextValue));

  /// Calls [next] with [nextValue] after checking it is the value type [V] of this model.
  ///
  /// Throws a [ModelTypeError] if [nextValue] is not [V].
  @nonVirtual
  M nextFromDynamic(dynamic nextValue) => nextValue is V ? next(nextValue) : throw ModelTypeError(this, nextValue);

  /// Calls [nextFromDynamic] after applying [updater] to the current model [value].
  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  /// Calls [next] with [serialized] after applying [fromSerialized] to it.
  ///
  /// Logs a [DeserialisationException] as a *WARNING* message (instead of throwing it) if [fromSerialized] returns null,
  /// indicating [serialized] could not be deserialized.
  @nonVirtual
  M nextFromSerialized(dynamic serialized) {
    final V serializedValue = fromSerialized(serialized);
    return serializedValue == null
        ? logExceptionAndReturn(this, DeserialisationException(this, serialized))
        : next(serializedValue);
  }

  /// Returns an instance of this model from [other] if [other] shares a history with this model.
  ///
  /// Throws a [ModelHistoryEqualityError] if it does not.
  @nonVirtual
  M nextFromModel(ModelType other) =>
      hasEqualityOfHistory(other) ? buildFromModel(other) : throw ModelHistoryEqualityError(this, other);

  /// Returns an instance of this model based on [nextModel].
  ///
  /// Commonly overwritten by [ValueType]s.
  @protected
  M buildFromModel(M nextModel) => nextModel;

  /// Determines whether [other] shares a history with this model.
  ///
  /// Commonly overwritten by [ValueType]s.
  bool hasEqualityOfHistory(ModelType other) => identical(this.initial, other.initial);

  // serialization methods

  /// Returns the current model [value] as a serializable object.
  ///
  /// The returned object should be serializable using the `JSON.encode` method.
  dynamic asSerializable();

  /// Converts [serialized] to the value type [V] of this model.
  ///
  /// [serialized] will normally be the value returned by [asSerializable].
  ///
  /// This method is commonly overwritten by sub-classes
  V fromSerialized(dynamic serialized) => serialized is V ? serialized : null;

  @override
  List<Object> get props => [value];

  // reflective methods

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  /// Debug toString method including the [fieldLabel], if it exists
  String toLongString() => "${fieldLabel == null ? "" : "'$fieldLabel' : "}" + toString();

  /// Debug toString method excluding the model's value
  String toShortString() => "${fieldLabel == null ? "" : "'$fieldLabel' : "}$modelType";

  /// Debug toString method
  @override
  String toString() => "<$modelType>($value)";
}
