import 'package:immutable_model/src/v2/immutable_entities/immutable_entity.dart';
import 'package:meta/meta.dart';

abstract class ModelEntity<V> extends ImmutableEntity<V> {
  @nonVirtual
  ModelEntity<V> updateWith(dynamic update) => this.update(deserialize(update));

  @protected
  V deserialize(dynamic update);

  dynamic asSerializable() => value;
}

// ModelChild :: asSerializable : Map<String, ModelEntity> -> Map<String, dynamic>
