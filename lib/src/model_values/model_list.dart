import 'package:built_collection/built_collection.dart';

import '../immutable_model_value.dart';

class ModelList<V> extends ImmutableModelValue<ModelList<V>, BuiltList<V>> {
  final bool append;

  final ValueValidator<V> itemValidator;
  final ValueSerializer<V> itemSerializer;
  final ValueDeserializer<V> itemDeserializer;

  ModelList._(ModelList<V> instance, BuiltList<V> nextValue)
      : itemValidator = instance.itemValidator,
        itemSerializer = instance.itemSerializer,
        itemDeserializer = instance.itemDeserializer,
        append = instance.append,
        super.next(instance, nextValue);

  // if append is false, it means you want to replace
  // manages it's own validtor as the validtion shouldn't apply to the whole list i.e. [value], only to elemnts that update it
  ModelList(this.itemSerializer, this.itemDeserializer, [List<V> defaultList, this.itemValidator, this.append = true])
      : super(
    serializer: (cl) => cl.map((li) => itemSerializer(li)).toList(growable: false),
    deserializer: null,
    defaultValue: BuiltList.of(defaultList ?? <V>[]),
    validator: null,
  ) {
    _safeValidateList(value);
  }

  BuiltList<V> _toTypedBuiltList(List<dynamic> l) =>
      l is List<V> ? BuiltList.of(l) : BuiltList.of(l.map((li) => _safeDeserializeListItem(li)));

  V _safeDeserializeListItem(dynamic item) {
    try {
      return itemDeserializer(item);
    } catch (e) {
      throw Exception("couldn't deserialize $item into type $V");
    }
  }

  BuiltList<V> _safeValidateList(BuiltList<V> l) => l..forEach((li) => _safeValidateListItem(li));

  V _safeValidateListItem(V item) {
    if (itemValidator != null && item != null) itemValidator(item);
    return item;
  }

  @override
  ModelList<V> set(BuiltList<V> v) => ModelList._(this,
      v == null ? null : append ? (value.rebuild((lb) => lb.addAll(_safeValidateList(v)))) : _safeValidateList(v));

  @override
  ModelList<V> setFrom(v) => v is List<dynamic> // check it's a list
                             ? set(_safeValidateList(_toTypedBuiltList(v)))
                             : throw ValueTypeException(List, v.runtimeType, v);
}

class ModelPrimitiveList<V> extends ModelList<V> {
  ModelPrimitiveList._(ModelPrimitiveList<V> instance, BuiltList<V> nextValue) : super._(instance, nextValue);

  ModelPrimitiveList([List<V> defaultList, ValueValidator<V> itemValidator, bool append = true])
      : super((li) => li, (si) => si is V ? si : throw (ValueTypeException(V, si.runtimeType, si)), defaultList,
      itemValidator, append);
}