import 'package:meta/meta.dart';

/// Defines an immutable entity that accepts and returns a value with type [V]
abstract class ImmutableEntity<F extends ImmutableEntity<F,V>, V> {
  V get value;

  V validate(V valueToValidate);

  /// Will create a new instance of the ImmutableEntity without (post) value validation
  @protected
  F build(V nextValue);

  @nonVirtual
  F update(V nextValue) => build(nextValue == null ? null : validate(nextValue));

  @nonVirtual
  F reset() => build(null);

  @override
  String toString() => "$value ($V)";
}
