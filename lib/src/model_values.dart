import 'immutable_model.dart';
import 'immutable_model_value.dart';

class ModelValue<V> extends ImmutableModelValue<ModelValue<V>, V> {
  ModelValue._(ModelValue<V> inst, V nextValue) : super.next(inst, nextValue);

  ModelValue([V defaultValue, Validator<V> validator]): super(defaultValue, validator);

  @override
  asSerializable() => value;

  @override
  ModelValue<V> set(V v) => ModelValue._(this, v);



  @override
  ModelValue<V> setFrom(v) => v is V ? set(v) : throw Exception('Expected $V but got ${v.runtimeType}: $v');

  @override
  ModelValue<V> reset() => set(null);
}

class ModelChild extends ImmutableModelValue<ModelChild, ImmutableModel> {
  ModelChild._(ModelChild inst, ImmutableModel nextValue) : super.next(inst, nextValue);

  ModelChild(Map<String, ImmutableModelValue> defaultModel) : super(ImmutableModel(defaultModel));

  @override
  Map<String, ImmutableModelValue> asSerializable() => value.asMap();

  @override
  ModelChild set(ImmutableModel v) => ModelChild._(this, v);

  @override
  ModelChild setFrom(v) => v is Map<String, dynamic>
      ? set(value.updateWith(v))
      : throw Exception('v is ${v.runtimeType} not Map<String, dynamic>, with:\n$v');

  @override
  ModelChild reset() => set(null);

  @override
  String toString() => value.toString();
}
