import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

// Serializable Valid type

mixin ModelType<T extends ModelType<T, V>, V> implements ValidType<T, V> {
  String get label;

  @nonVirtual
  T nextWithSerialized(dynamic serialized) {
    if (serialized == null) return this as T;

    final v = deserializer(serialized);
    if (v == null) {
      // todo: logging
      // ValidLogger.logException(ModelDeserializationException(T, serialized));
      return this as T;
    }
    return next(v);
  }

  @nonVirtual
  dynamic? asSerializable() => value == null ? null : serializer(value!);

  dynamic serializer(V currentValue);

  V? deserializer(dynamic serialized);
}
