import '../immutable_model_value.dart';

// todo: could add a params that lets you specify the name of the field to the constricutor of ImmModVal.
// : would help with debugging

class ModelValue<V> extends ImmutableModelValue<ModelValue<V>, V> {
  ModelValue._(ModelValue<V> instance, V nextValue) : super.next(instance, nextValue);

  ModelValue(ValueSerializer<V> serializer, ValueDeserializer<V> deserializer,
      [V defaultValue, ValueValidator<V> validator])
      : super(serializer: serializer, deserializer: deserializer, defaultValue: defaultValue, validator: validator);

  @override
  ModelValue<V> set(V v) => ModelValue._(this, v);
}

class ModelPrimitiveValue<V> extends ModelValue<V> {
  ModelPrimitiveValue._(ModelPrimitiveValue<V> instance, V nextValue) : super._(instance, nextValue);

  ModelPrimitiveValue([V defaultValue, ValueValidator<V> validator])
      : super((cv) => cv, (sv) => sv is V ? sv : throw ValueTypeException(V, sv.runtimeType, sv), defaultValue,
            validator);
}
