import 'package:immutable_model/src/immutable_entity.dart';
import 'package:meta/meta.dart';

mixin ModelEntity<F extends ImmutableEntity<F,V>, V> on ImmutableEntity<F, V> {
  @nonVirtual
  ModelEntity<F, V> updateWith(dynamic update) => create(this, this.update(deserialize(update)))

  @protected
  ModelEntity<F, V> create(ModelEntity<F, V> instance, ImmutableEntity<F,V> immutableEntity);

  @protected
  V deserialize(dynamic update);

  dynamic asSerializable();
}

// ModelChild :: asSerializable : Map<String, ModelEntity> -> Map<String, dynamic>
