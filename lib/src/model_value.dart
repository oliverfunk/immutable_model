import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ValueTypeException implements Exception {
  final Type expected;
  final Type received;
  final dynamic value;

  ValueTypeException(this.expected, this.received, this.value);

  @override
  String toString() => 'Expected $expected but received $received: $value';
}

typedef V Updater<V>(V currentValue);

abstract class ModelValue<E extends ModelValue<E, V>, V> extends Equatable {
  V get value;

  // should propagate null's
  V validate(V toValidate) => toValidate;

  dynamic asSerializable() => value;

  @protected
  // should propagate null's
  V deserialize(dynamic serialized) => serialized == null
      ? serialized
      : serialized is V ? serialized : throw ValueTypeException(V, serialized.runtimeType, serialized);

  @protected
  // if null, should set the value to the initial value
  E build(V update);

  @nonVirtual
  E reset() => build(null);

  @nonVirtual
  E update(V value) => build(validate(value));

  @nonVirtual
  E updateFrom(dynamic value) => build(validate(deserialize(value)));

  @nonVirtual
  E updateWith(Updater<V> updater) => build(validate(updater(value)));

  @override
  List<Object> get props => [value];

  @override
  String toString() => "$value ($V)";
}
