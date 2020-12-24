import 'package:immutable_model/src/model_type.dart';
import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../immutable_model/immutable_model.dart';

class ModelInner<M extends ImmutableModel<M, dynamic>>
    extends ValidValueType<ModelInner<M>, M> with ModelType<ModelInner<M>, M> {
  final String _label;

  ModelInner(
    M model, {
    required String label,
  })   : _label = label,
        super.initial(
          model,
        );

  ModelInner._next(
    ModelInner<M> previous,
    M nextModel,
  )   : _label = previous._label,
        super.constructNext(previous, nextModel);

  @override
  @protected
  ModelInner<M> buildNext(M nextModel) => ModelInner._next(this, nextModel);

  @override
  String get label => _label;

  @override
  Map<String, dynamic> serializer(M currentValue) => currentValue.toJson();

  @override
  // value cannot be null
  M? deserializer(dynamic serialized) =>
      serialized is Map<String, dynamic> ? value!.fromJson(serialized) : null;
}
