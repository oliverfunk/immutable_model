import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

typedef dynamic ValueUpdater(dynamic currentValue);

// *todo: check what null does on the next methods

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  M get initialModel;

  @nonVirtual
  bool get isInitial => identical(this, initialModel);

  /// Determines whether [toValidate] is valid or not.
  bool checkValid(V toValidate);

  @protected
  dynamic whichInvalid(V invalid) => invalid;

  /// Validates [toValidate]. If it is valid, [toValidate] is returned and if not a [ImmutableModelValidationException] is thorwn.
  @protected
  @nonVirtual
  V validate(V toValidate) =>
      checkValid(toValidate) ? toValidate : throw ImmutableModelValidationException(this, whichInvalid(toValidate));

  /// Returns a new [M] given the [next] value of [V].
  @protected
  M build(V next);

  // value update methods

  /// Validate [value] and return a new instance of this [ModelValue].
  /// If [value] is null, return the initial model
  @nonVirtual
  M next(V value) => value == null ? initialModel : build(validate(value));

  @nonVirtual
  M nextFromDynamic(dynamic value) => value is V ? next(value) : throw ImmutableModelTypeException(this, value);

  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  @nonVirtual
  M nextFromModel(M other) => hasEqualityOfHistory(other) ? other : throw ImmutableModelEqualityException(this, other);

  bool hasEqualityOfHistory(M other) => identical(this.initialModel, other.initialModel);

  // serialisation methods

  /// Return this [ModelValue] as a serializable object for the JSON.encode() method.
  dynamic asSerializable() => value;

  /// Return [serialized] as the value of this [ModelValue].
  M deserialize(dynamic serialized) =>
      serialized is V ? next(serialized) : throw ImmutableModelDeserialisationException(this, serialized);

  @override
  List<Object> get props => [value];

  // reflective methods

  /// Returns the model field name string for this [ModelValue] in some.
  /// Useful for reflection
  String get fieldLabel => null;

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  String toLongString() => "${fieldLabel == null ? "" : "'$fieldLabel' : "}${runtimeType}($value)";

  @override
  String toString() => "<$valueType>($value)";
}
