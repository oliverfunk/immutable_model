import 'package:meta/meta.dart';

/// Defines an immutable model entity that accepts and returns values of type [V}
abstract class ModelEntity<F extends ModelEntity<F,V>, V> {
  // value validation:
  V get value;

  V validate(V valueToValidate);

  /// Will create a new instance of the ImmutableEntity without (post) value validation
  @protected
  F build(V nextValue);

  @nonVirtual
  F update(V nextValue) => build(nextValue == null ? null : validate(nextValue));

  @nonVirtual
  F reset() => build(null);

  // type validation:
  @nonVirtual
  F updateWith(dynamic update) => this.update(deserialize(update));

  @protected
  V deserialize(dynamic update);

  dynamic asSerializable();

  @override
  String toString() => "$value ($V)";

}

// ModelChild :: asSerializable : Map<String, ModelEntity> -> Map<String, dynamic>
