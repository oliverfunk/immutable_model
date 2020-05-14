import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ValueTypeException implements Exception {
  final Type expected;
  final Type received;
  final dynamic value;

  ValueTypeException(this.expected, this.received, this.value);

  @override
  String toString() => 'Expected $expected but got $received: $value';
}

abstract class ModelValue<E extends ModelValue<E, V>, V> extends Equatable{
  V get value;

  // should propagate null's
  V validate(V toValidate) => toValidate;

  dynamic asSerializable() => value;

  @protected
  // should propagate null's
  V deserialize(dynamic serialized) =>
      serialized == null ? serialized: serialized is V ? serialized : throw Error();

  @protected
  // if null, should set the value to the initial value
  E build(V nextValue);

  @nonVirtual
  E reset() => build(null);

  @nonVirtual
  E update(V nextValue) => build(validate(nextValue));

  @nonVirtual
  E updateFrom(dynamic nextValue) => build(validate(deserialize(nextValue)));

  @override
  List<Object> get props => [value];

  @override
  String toString() => "$value ($V)";
}
