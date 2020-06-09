import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

typedef V Updater<V>(V currentValue);

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  // should propagate null's
  V validate(V toValidate) => toValidate;

  dynamic asSerializable() => value;

  @protected
  // should propagate null's
  V deserialize(dynamic serialized) => serialized == null
      ? serialized
      : serialized is V ? serialized : throw ModelTypeException<V>(serialized, modelFieldName);

  // all of these behavuours can be put into imm mod

  @protected
  // if null, should set the value to the initial value
  M build(V update);

  @nonVirtual
  M reset() => build(null);

  @nonVirtual
  M update(V value) => build(validate(value));

  @nonVirtual
  M updateFrom(dynamic value) => build(validate(deserialize(value)));

  @nonVirtual
  M updateWith(Updater<V> updater) => build(validate(updater(value)));

  @nonVirtual
  Type get type => V;

  @override
  List<Object> get props => [value];

  String get modelFieldName => null;

  @override
  String toString() => "${modelFieldName == null ? "" : modelFieldName + ": "}$value ($V)";
}
