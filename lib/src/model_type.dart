import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'utils/log.dart';
import 'errors.dart';
import 'exceptions.dart';

typedef bool ValueValidator<V>(V value);
typedef dynamic ValueUpdater(dynamic currentValue);

@immutable
abstract class ModelType<M extends ModelType<M, V>, V> extends Equatable {
  V get value;

  final M _initialModel;
  M get inital => _initialModel ?? this;

  @nonVirtual
  bool get isInitial => identical(this, inital);

  /// Returns the model field name string for this [ModelType] in some.
  final String fieldLabel;

  final ValueValidator<V> _validator;
  @nonVirtual
  bool validate(V toValidate) => _validator == null || _validator(toValidate);

  ModelType.inital(
    V initalValue,
    ValueValidator<V> validator,
    this.fieldLabel,
  )   : _validator = validator,
        _initialModel = null {
    if (initalValue != null && !validate(initalValue)) {
      logException(ValidationException(this, value));
      throw ModelInitializationError(this, value);
    }
  }

  ModelType.fromPrevious(M previous)
      : _initialModel = previous.inital,
        _validator = previous._validator,
        fieldLabel = previous.fieldLabel;

  /// Returns a new [M] given the [nextValue] value of [V].
  @protected
  M buildNext(V nextValue);

  /// Validate [value] and return a new instance of this [ModelType].
  @nonVirtual
  M next(V value) => value == null
      ? this
      : validate(value) ? buildNext(value) : logExceptionAndReturn(this, ValidationException(this, value));

  @nonVirtual
  M nextFromDynamic(dynamic value) => value is V ? next(value) : throw ModelInitializationError(this, value);

  @nonVirtual
  M nextFromFunc(ValueUpdater updater) => nextFromDynamic(updater(value));

  @nonVirtual
  M nextFromSerialized(dynamic value) {
    final V serialisedValue = fromSerialized(value);
    return serialisedValue == null
        ? logExceptionAndReturn(this, DeserialisationException(this, value))
        : next(serialisedValue);
  }

  @protected
  M buildFromModel(M nextModel) => nextModel;

  @nonVirtual
  M nextFromModel(ModelType other) =>
      hasEqualityOfHistory(other) ? buildFromModel(other) : throw ModelHistoryEqualityError(this, other);

  bool hasEqualityOfHistory(ModelType other) => identical(this.inital, other.inital);

  // serialisation methods

  /// Return this [ModelType] as a serializable object for the JSON.encode() method.
  dynamic asSerializable() => value;

  /// Return [serialized] as a value of type [V] for this [ModelType].
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
