import 'package:immutable_model/src/immutable_entity.dart';
import 'package:meta/meta.dart';

mixin ModelEntity<V> on ImmutableEntity<V> {
  @nonVirtual
  ModelEntity<V> updateWith(dynamic update) => this.update(deserialize(update));

  @protected
  V deserialize(dynamic update);

  dynamic asSerializable();
}

// ModelChild :: asSerializable : Map<String, ModelEntity> -> Map<String, dynamic>
