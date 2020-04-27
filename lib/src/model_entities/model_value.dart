import 'package:immutable_model/src/cloneable.dart';
import 'package:immutable_model/src/model_entity.dart';

typedef void ValueValidator<V>(V value);
typedef dynamic ValueSerializer<V>(V item);
typedef V ValueDeserializer<V>(dynamic item);

class ModelValue<V> extends ModelEntity<ModelValue<V>, V> {
  final ValueValidator<V> validator;

  final V _value;
  final V _defaultValue;

  final ValueSerializer<V> valueSerializer;
  final ValueDeserializer<V> valueDeserializer;

  ModelValue._([ModelValue<V> instance, this._value])
      : validator = instance.validator,
        _defaultValue = instance._defaultValue,
        valueSerializer = instance.valueSerializer,
        valueDeserializer = instance.valueDeserializer;

  ModelValue(this.valueSerializer, this.valueDeserializer, [this._defaultValue, this.validator]) : _value = null;

  V _safeValidate(V valueToValidate) {
    if (validator != null && valueToValidate != null) validator(valueToValidate);
    return valueToValidate;
  }

  V _safeInstance() => _value ?? _defaultValue;

// todo: check if this works.
  @override
  V get value => V is Cloneable ? (_safeInstance() as Cloneable).clone() : _safeInstance();

  @override
  V validate(V valueToValidate) => _safeValidate(valueToValidate);

  @override
  ModelValue<V> build(V nextValue) => ModelValue._(this, nextValue);

  @override
  V deserialize(update) => valueDeserializer(update);

  @override
  asSerializable() => valueSerializer(value);
}

class ModelPrimitiveValue<V> extends ModelValue<V> {
  ModelPrimitiveValue([V defaultValue, ValueValidator<V> validator])
      : super((v) => v, (i) => i is V ? i : throw Exception("$i is not $V"), defaultValue, validator) {
    assert(V == double || V == int || V == String || V == bool);
  }
  // might override get value to clone string if V is String
}
