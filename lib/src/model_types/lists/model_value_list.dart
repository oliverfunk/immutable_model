import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../../model_type.dart';
import '../primitives/model_value_type.dart';

class ModelValueList<V> extends ValidValueListType<ModelValueList<V>, V>
    with ModelType<ModelValueList<V>, List<V>> {
  final String _label;

  ModelValueList(
    List<V> initialValues, {
    required ModelValueType validator,
    required String label,
  })   : _label = label,
        super.initial(
          initialValues,
          validator: validator,
        );

  ModelValueList.numberOf(
    int numberOf, {
    required ModelValueType validator,
    required String label,
  })   : _label = label,
        super.initialNumberOf(
          numberOf,
          validator: validator,
        );

  ModelValueList._next(ModelValueList<V> previous, List<V> nextList)
      : _label = previous._label,
        super.constructNext(previous, nextList);

  @override
  @protected
  ModelValueList<V> buildNext(List<V> nextList) =>
      ModelValueList._next(this, nextList);

  @override
  String get label => _label;

  @override
  List serializer(List<V> currentList) => List.unmodifiable(
        currentList.map(
          (i) => (validator as ModelValueType).serializer(i),
        ),
      );

  @override
  List<V>? deserializer(dynamic serialized) {
    if (serialized is Iterable) {
      final returnList = <V>[];
      for (var item in serialized) {
        final mv = (validator as ModelValueType).deserializer(item);
        if (mv == null) return null;
        returnList.add(mv);
      }
    } else {
      return null;
    }
  }
}
