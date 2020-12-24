import 'package:valid/valid.dart';

import '../../model_type.dart';
import '../primitives/model_value_type.dart';

class ModelValueList<V> extends ValidValueListType<ModelValueList<V>, V>
    with ModelType<ModelValueList<V>, List<V>> {
  final String _fieldLabel;

  ModelValueList(
    List<V> initialValues, {
    required ModelValueType validator,
    required String fieldLabel,
  })   : _fieldLabel = fieldLabel,
        super.initial(
          initialValues,
          validator: validator,
        );

  ModelValueList.numberOf(
    int numberOf, {
    required ModelValueType validator,
    required String fieldLabel,
  })   : _fieldLabel = fieldLabel,
        super.initialNumberOf(
          numberOf,
          validator: validator,
        );

  ModelValueList._next(ModelValueList<V> previous, List<V> nextList)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextList);

  @override
  ModelValueList<V> buildNext(List<V> nextList) =>
      ModelValueList._next(this, nextList);

  @override
  String get label => _fieldLabel;

  @override
  List serializer(List<V> currentList) => List.unmodifiable(
        currentList.map(
          (i) => (validator as ModelValueType).serializer(i),
        ),
      );

  @override
  List<V>? deserializer(dynamic serialized) {
    if (serialized is Iterable) {
      // if an item in serialized cannot be deserialized,
      // an instance of the default model will be used
      return serialized
          .map<V>((i) => (validator as ModelValueType).deserializer(i))
          .toList();
    } else {
      return null;
    }
  }
}
