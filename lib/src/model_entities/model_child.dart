import 'package:immutable_model/src/immutable_entities/immutable_model.dart';
import 'package:immutable_model/src/model_entity.dart';

class ModelChild extends ImmutableModel with ModelEntity<Map<String, dynamic>> {
  ModelChild(Map<String, ModelEntity> defaultModel) : super(defaultModel);

  @override
  Map<String, dynamic> deserialize(entity) => entity is Map<String, dynamic> ? entity : throw Exception('not map');

  @override
  Map<String, dynamic> asSerializable() => asSerializableMap();
}