import 'package:meta/meta.dart';

abstract class ModelValue<E extends ModelValue<E, V>, V> {
  V get value;

  V validate(V toValidate) => toValidate;

  V deserialize(dynamic serialized) => serialized is V ? serialized : throw Error();

  dynamic asSerializable() => value;

  @protected
  E build(V nextValue);

  @nonVirtual
  E reset() => build(null);

  @nonVirtual
  // should fail on null nextValue
  E update(V nextValue) => build(validate(nextValue));

  @nonVirtual
  E updateFrom(dynamic nextValue) => build(validate(deserialize(nextValue)));

  @override
  String toString() => "$value ($V)";
}
