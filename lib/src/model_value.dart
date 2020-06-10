import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

typedef dynamic ValueUpdater(dynamic currentValue);

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  M get initialModel;

  /// Validates [toValidate] using the defined [validator] for this [ModelValue].
  V validate(V toValidate) => toValidate;

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
  V deserializer(dynamic jsonValue) => jsonValue is V ? jsonValue : throw ModelFromJsonException(this, jsonValue);

  // reflective methods

  /// Returns the model field name string for this [ModelValue] in some.
  /// Useful for reflection and exceptions.
  String get modelFieldName => null;

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  @override
  List<Object> get props => [value];

  String toLongString() => "${modelFieldName == null ? "" : "'$modelFieldName':"}$modelType($value)";

  @override
  String toString() => "$value ($valueType)";
}
