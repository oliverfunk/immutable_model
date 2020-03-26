import 'package:immutable_model/src/v2/immutable_entities/immutable_model.dart';
import 'package:immutable_model/src/v2/model_entities/model_entity.dart';

class ModelChild extends ImmutableModel with ModelEntity<Map<String, dynamic>> {
  ModelChild(Map<String, ModelEntity> defaultModel) : super(defaultModel);

  @override
  Map<String, dynamic> deserialize(entity) => entity is Map<String, dynamic> ? entity : throw Exception('not map');
}