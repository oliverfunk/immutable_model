import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'utils/log.dart';
import 'errors.dart';
import 'exceptions.dart';

typedef dynamic ValueUpdater(dynamic currentValue);
typedef bool ValueValidator<V>(V value);

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  final M _initialModel;
  M get inital => _initialModel ?? this;

  @nonVirtual
  bool get isInitial => identical(this, inital);

  /// Returns the model field name string for this [ModelValue] in some.
  final String fieldLabel;

  final ValueValidator<V> _validator;
  @nonVirtual
  bool validate(V toValidate) => _validator == null || _validator(toValidate);

  ModelValue.inital(
    V initalValue,
    ValueValidator<V> validator,
    this.fieldLabel,
  )   : assert(initalValue == null || validator == null || validator(initalValue),
            "Initalising with invalid value: $initalValue"),
        _validator = validator,
        _initialModel = null;

  ModelValue.fromLast(M last)
      : _initialModel = last.inital,
        _validator = last._validator,
        fieldLabel = last.fieldLabel;

  /// Returns a new [M] given the [next] value of [V].
  @protected
  M build(V next);

  /// Validate [value] and return a new instance of this [ModelValue].
  @nonVirtual
  M next(V value) => value == null
      ? this
      : validate(value) ? build(value) : logExceptionAndReturn(this, ValidationException(this, value));

  @nonVirtual
  M nextFromDynamic(dynamic value) => value is V ? next(value) : throw ModelTypeError(this, value);

  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  @nonVirtual
  M nextFromSerialized(dynamic value) {
    final V serialisedValue = fromSerialized(value);
    if (serialisedValue == null) {
      return logExceptionAndReturn(this, DeserialisationException(this, value));
    } else {
      return next(serialisedValue);
    }
  }

  @nonVirtual
  M nextFromModel(M other) => hasEqualityOfHistory(other) ? other : throw ModelHistoryEqualityError(this, other);

  bool hasEqualityOfHistory(M other) => identical(this.inital, other.inital);

  // serialisation methods

  /// Return this [ModelValue] as a serializable object for the JSON.encode() method.
  dynamic asSerializable() => value;

  /// Return [serialized] as a value of type [V] for this [ModelValue].
  V fromSerialized(dynamic serialized) => serialized is V ? serialized : null;

  @override
  List<Object> get props => [value];

  // reflective methods

  @nonVirtual
  Type get modelType => M;

  @nonVirtual
  Type get valueType => V;

  // misc

  String toLongString() => "${fieldLabel == null ? "" : "'$fieldLabel' : "}${runtimeType}($value)";

  @override
  String toString() => "<$valueType>($value)";
}
