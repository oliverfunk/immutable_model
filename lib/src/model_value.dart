import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

typedef dynamic ValueUpdater(dynamic currentValue);

// *todo: check what null does on the next methods

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  M get initialModel;

  /// Determines whether [toValidate] is valid or not.
  bool isValid(V toValidate);

  @protected
  dynamic whichInvalid(V invalid) => invalid;

  /// Validates [toValidate]. If it is valid, [toValidate] is returned and if not a [ModelValidationException] is thorwn.
  @protected
  @nonVirtual
  V validate(V toValidate) =>
      isValid(toValidate) ? toValidate : throw ModelValidationException(this, whichInvalid(toValidate));

  /// Returns a new [M] given the [next] value of [V].
  @protected
  M build(V next);

  // value update methods

  /// Validate [value] and return a new instance of this [ModelValue].
  /// If [value] is null, return the initial model
  @nonVirtual
  M next(V value) => value == null ? initialModel : build(validate(value));

  @nonVirtual
  M nextFromDynamic(dynamic value) => value is V ? next(value) : throw ModelTypeException(this, value);

  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  @nonVirtual
  M nextFromModel(M other) => hasEqualityOfHistory(other) ? other : throw ModelEqualityException(this, other);

  bool hasEqualityOfHistory(M other) => identical(this.initialModel, other.initialModel);

  // serialisation methods

  /// Return this [ModelValue] as a serializable object for the JSON.encode() method.
  dynamic asSerializable() => value;

  /// Return [jsonValue] as the value of this [ModelValue].
  V deserialize(dynamic jsonValue) => jsonValue is V ? jsonValue : throw ModelFromJsonException(this, jsonValue);

  @override
  List<Object> get props => [value];

  // reflective methods

  /// Returns the model field name string for this [ModelValue] in some.
  /// Useful for reflection in exceptions.
  String get modelFieldName => null;

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  String toLongString() => "${modelFieldName == null ? "" : "'$modelFieldName':"}$modelType($value)";

  @override
  String toString() => "<$valueType>($value)";
}
