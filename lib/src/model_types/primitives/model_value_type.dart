import 'package:valid/valid.dart';

import '../../serializable_valid_type.dart';

abstract class ModelValueType<T extends ModelValueType<T, V>, V>
    extends ValidPrimitiveValueType<T, V> with SerializableValidType<T, V> {
  final String _fieldLabel;

  ModelValueType.initial(
    this._fieldLabel,
    V initialValue, [
    Validator<V>? validator,
  ]) : super.initial(initialValue, validator);

  ModelValueType.constructNext(T previous, V nextValue)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextValue);

  @override
  String get fieldLabel => _fieldLabel;

  @override
  dynamic serializer(V currentValue) => currentValue;

  @override
  V? deserializer(dynamic serialized) => serialized is V ? serialized : null;
}
