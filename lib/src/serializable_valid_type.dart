import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import 'exceptions.dart';

mixin SerializableValidType<T extends SerializableValidType<T, V>, V>
    implements ValidType<T, V> {
  String get fieldLabel;

  @nonVirtual
  T nextWithSerialized(dynamic serialized) {
    if (serialized == null) return this as T;

    final v = deserializer(serialized);
    if (v == null) {
      // ValidLogger.logException(ModelDeserializationException(T, serialized));
      return this as T;
    }
    return next(v);
  }

  @nonVirtual
  dynamic asSerializable() => serializer(value);

  dynamic serializer(V currentValue);

  V? deserializer(dynamic serialized);
}
