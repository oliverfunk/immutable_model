import '../immutable_model.dart';
import '../immutable_model_value.dart';

class ModelChild extends ImmutableModelValue<ModelChild, ImmutableModel> {
  ModelChild._(ModelChild instance, ImmutableModel nextValue) : super.next(instance, nextValue);

  ModelChild(Map<String, ImmutableModelValue> defaultModel)
      : super(
      serializer: (cv) => cv.asSerializable(),
      deserializer: null,
      defaultValue: ImmutableModel(defaultModel),
      validator: null);

  @override
  ModelChild set(ImmutableModel v) => ModelChild._(this, v);

  @override
  ModelChild setFrom(v) =>
      v is Map<String, dynamic> ? set(value.updateWith(v)) : throw ValueTypeException(Map, v.runtimeType, v);

  @override
  String toString() => value.toString();
}