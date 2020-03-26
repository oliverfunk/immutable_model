import 'package:immutable_model/src/immutable_entities/immutable_value.dart';

import '../model_entity.dart';

typedef V ValueDeserializer<V>(dynamic item);
typedef dynamic ValueSerializer<V>(V item);

class ModelValue<V> extends ImmutableValue<V> with ModelEntity<ImmutableValue<V>, V> {
  final ValueSerializer<V> valueSerializer;
  final ValueDeserializer<V> valueDeserializer;

  ModelValue(this.valueSerializer, this.valueDeserializer, [V defaultValue, Validator<V> validator])
      : super(defaultValue, validator);

  @override
  V deserialize(update) => valueDeserializer(update);

  @override
  asSerializable() => valueSerializer(value);
}

class ModelPrimitiveValue<V> extends ModelValue<V> {
  ModelPrimitiveValue([V defaultValue, Validator<V> validator])
      : super((v) => v, (i) => i is V ? i : throw Exception("$i is not $V"), defaultValue, validator);
}