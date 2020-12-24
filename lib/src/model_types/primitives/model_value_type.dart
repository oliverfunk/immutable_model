import 'package:valid/valid.dart';

import '../../model_type.dart';

abstract class ModelValueType<T extends ModelValueType<T, V>, V>
    extends ValidPrimitiveValueType<T, V> with ModelType<T, V> {
  final String _fieldLabel;

  ModelValueType.initial(
    V? initialValue, {
    Validator<V>? validator,
    required String fieldLabel,
  })   : _fieldLabel = fieldLabel,
        super.initial(
          initialValue,
          validator: validator,
        );

  ModelValueType.constructNext(T previous, V nextValue)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextValue);

  @override
  String get label => _fieldLabel;

  @override
  dynamic serializer(V currentValue) => currentValue;

  @override
  V? deserializer(dynamic serialized) => serialized is V ? serialized : null;
}
