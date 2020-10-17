import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'errors.dart';
import 'exceptions.dart';
import 'utils/log.dart';

/// A function that validates the [value] passed to it.
typedef ValueValidator<V> = bool Function(V value);

/// A function that updates the value of a model based on its [currentValue].
typedef ValueUpdater = dynamic Function(dynamic currentValue);

/// An abstract base class that defines common model attributes and behaviors.
///
/// Any class that extends this must be immutable and will have equality based on its current [value],
/// as provided by [Equatable].
@immutable
abstract class ModelType<M extends ModelType<M, V>, V> extends Equatable {
  /// A copy of model's current value.
  ///
  /// Edit changing the values won't change the value in the model.
  V get value;

  /// The initial instance of this model.
  ///
  /// Can be `null`.
  final M _initialModel;

  /// The initial instance of this model.
  ///
  /// Used when resetting a model and commonly to determine whether another model
  /// shares a common history with this one (via [hasEqualityOfHistory]).
  M get initial => _initialModel ?? this;

  /// True if this instance is the initial instance.
  @nonVirtual
  bool get isInitial => identical(this, initial);

  /// The field label associated with this model
  ///
  /// Generally set when used in a [ModelInner] or [ImmutableModel]. This is not guaranteed, however.
  ///
  /// Used in debugging or dynamically accessing this model via its field label.
  final String fieldLabel;

  /// The validator applied to updates to this model.
  final ValueValidator<V> _validator;

  /// Determines whether [toValidate] is valid or not.
  ///
  /// Returns `true` if it is and `false` otherwise.
  @nonVirtual
  bool validate(V toValidate) => _validator == null || _validator(toValidate);

  /// Constructor for the first instance of this [ModelType].
  ///
  /// If the supplied [initialValue] and [validator] are not `null`,
  /// [validator] will be run on the [initialValue].
  ///
  /// Throws a [ModelInitialValidationError] if [validator] returns false after being run on [initialValue].
  ModelType.initial([
    V initialValue,
    ValueValidator<V> validator,
    this.fieldLabel,
  ])  : _validator = validator,
        _initialModel = null {
    // if only there was some way to do this before the instance was initialized...
    if (initialValue != null && validator != null && !validator(initialValue)) {
      logException(ValidationException(M, initialValue, fieldLabel));
      throw ModelInitialValidationError(M, value);
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
  /// Used to hook in the constructor of the sub-class that extends this.
  @protected
  M buildNext(V nextValue);

  /// Determines whether the model should build on [nextValue].
  ///
  /// This should not be an expensive call.
  ///
  /// [nextValue] cannot be `null`.
  @protected
  bool shouldBuild(V nextValue) => nextValue != value;

  /// Returns a new instance whose [value] is set to [nextValue],
  /// if [nextValue] is valid.
  ///
  /// If [nextValue] is not valid or is equal to the current [value],
  /// the current instance is returned (with no update applied)
  ///
  /// Logs a [ValidationException] as a *WARNING* message
  /// (instead of throwing it) if [nextValue] is not valid.
  @nonVirtual
  M next(V nextValue) => nextValue != null
      ? shouldBuild(nextValue)
          ? validate(nextValue)
              ? buildNext(nextValue)
              : logExceptionAndReturn(
                  this,
                  ValidationException(M, nextValue, fieldLabel),
                )
          : this
      : this;

  /// Calls [next] with [nextValue]
  /// after checking it is the value type [V] of this model.
  ///
  /// Throws a [ModelTypeError] if [nextValue] is not [V].
  @nonVirtual
  M nextFromDynamic(dynamic nextValue) =>
      nextValue is V ? next(nextValue) : throw ModelTypeError(this, nextValue);

  /// Calls [nextFromDynamic]
  /// after applying [updater] to the current model [value].
  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  /// Calls [next] with [serialized] after applying [fromSerialized] to it.
  ///
  /// Logs a [DeserialisationException] as a *WARNING* message
  /// (instead of throwing it) if [fromSerialized] returns `null`,
  /// indicating [serialized] could not be deserialized.
  @nonVirtual
  M nextFromSerialized(dynamic serialized) {
    final serializedValue = fromSerialized(serialized);
    return serializedValue != null
        ? next(serializedValue)
        : logExceptionAndReturn(
            this,
            DeserialisationException(M, serialized, fieldLabel),
          );
  }

  /// Returns an instance of this model from [other] if [other] shares a history with this model.
  ///
  /// Throws a [ModelHistoryEqualityError] if it does not.
  @nonVirtual
  M nextFromModel(ModelType other) => this != other
      ? hasEqualityOfHistory(other)
          ? buildFromModel(other)
          : throw ModelHistoryEqualityError(this, other)
      : this;

  /// Returns an instance of this model based on [nextModel].
  ///
  /// Commonly overwritten by [ValueType]s.
  @protected
  M buildFromModel(M nextModel) => nextModel;

  /// Determines whether [other] shares a history with this model.
  ///
  /// Commonly overwritten by [ValueType]s.
  bool hasEqualityOfHistory(ModelType other) =>
      identical(initial, other.initial);

  // serialization methods

  /// Returns the current [value] of this model in a serializable format.
  ///
  /// The returned object should be serializable using the `JSON.encode` method.
  dynamic asSerializable();

  /// Converts [serialized] to the value type [V] of this model and returns it.
  /// Returns `null` if [serialized] could not be converted.
  ///
  /// [serialized] will normally be the value returned by [asSerializable].
  ///
  /// This method is commonly overwritten by sub-classes
  V fromSerialized(dynamic serialized);

  @override
  List<Object> get props => [value];

  // reflective methods

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  /// Debug toString method including the [fieldLabel], if it exists, the [modelType] and model [value].
  String toLongString() =>
      "${fieldLabel == null ? "" : "'$fieldLabel' : "}${toString()}";

  /// Debug toString method including the [fieldLabel], if it exists, and the [modelType].
  String toShortString() =>
      "${fieldLabel == null ? "" : "'$fieldLabel' : "}$modelType";

  /// Debug toString method including the [modelType] and model [value].
  @override
  String toString() => "<$modelType>($value)";
}
