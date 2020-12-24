import 'package:valid/valid.dart';

import '../../model_type.dart';

abstract class ModelValueType<T extends ModelValueType<T, V>, V>
    extends ValidPrimitiveValueType<T, V> with ModelType<T, V> {
  final String _label;

  ModelValueType.initial(
    V? initialValue, {
    Validator<V>? validator,
    required String label,
  })   : _label = label,
        super.initial(
          initialValue,
          validator: validator,
        );

  ModelValueType.constructNext(T previous, V nextValue)
      : _label = previous._label,
        super.constructNext(previous, nextValue);

  @override
  String get label => _label;

  @override
  dynamic serializer(V currentValue) => currentValue;

  @override
  V? deserializer(dynamic serialized) => serialized is V ? serialized : null;
}
