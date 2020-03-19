import 'package:built_collection/built_collection.dart';

import 'immutable_model.dart';
import 'immutable_model_value.dart';

class ModelValue<V> extends ImmutableModelValue<ModelValue<V>, V> {
  ModelValue._(ModelValue<V> inst, V nextValue) : super.next(inst, nextValue);

  ModelValue([V defaultValue, Validator<V> validator]): super(defaultValue, validator);

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

class ModelList<V> extends ImmutableModelValue<ModelList<V>, BuiltList<V>> {

  final bool append;
  
  /// Used to validate elements in the list
  final Validator<V> elemValidator;

  ModelList._(ModelList<V> inst, BuiltList<V> nextValue) : elemValidator = inst.elemValidator, append = inst.append, super.next(inst, nextValue);

  // if append is false, it means you want to replace
  ModelList([List<V> defaultValue, this.elemValidator, this.append = true]): super(defaultValue.build()){
    defaultValue.forEach(elemValidator);
  }

  V _validElement(V e) => elemValidator(e) ? e : throw Exception('invalid elemnt');

  @override
  ModelList<V> set(BuiltList<V> v) => ModelList._(this, append ? (value.rebuild((lb) => lb.addAll(v))) : v);

  @override
  ModelList<V> setFrom(v) => v is List<dynamic>
                             ? set(BuiltList.from(v.map((e) => e is V ? _validElement(e) : throw ValueTypeException(V, e.runtimeType, e))))
                             : throw ValueTypeException(this.value.runtimeType, v.runtimeType, v);

  @override
  ModelList<V> reset() => set(null);
}