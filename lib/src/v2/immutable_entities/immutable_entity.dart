import 'package:meta/meta.dart';

/// Defines an immutable entity that returns a value with type [V]
abstract class ImmutableEntity<V> {
  V get value;

  V validate(V valueToValidate);

  /// Will create a new instance of the ImmutableEntity without (post) value validation
  @protected
  ImmutableEntity<V> build(V nextValue);

  @nonVirtual
  ImmutableEntity<V> update(V nextValue) => build(nextValue == null ? null : validate(nextValue));

  @nonVirtual
  ImmutableEntity<V> reset() => build(null);

  @override
  String toString() => "$value ($V)";
}
