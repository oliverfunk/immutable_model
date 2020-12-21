import 'package:valid/valid.dart';

import '../../serializable_valid_type.dart';
import '../primitives/model_value_type.dart';

class ModelValueList<V> extends ValidValueListType<ModelValueList<V>, V>
    with SerializableValidType<ModelValueList<V>, List<V>> {
  final String _fieldLabel;

  ModelValueList(
    this._fieldLabel,
    ModelValueType validator, [
    List<V> initialValues = const [],
  ]) : super.initial(validator, initialValues);

  ModelValueList.numberOf(
    this._fieldLabel,
    ModelValueType validator,
    int numberOf,
  ) : super.initialNumberOf(validator, numberOf);

  ModelValueList._next(ModelValueList<V> previous, List<V> nextList)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextList);

  @override
  ModelValueList<V> buildNext(List<V> nextList) =>
      ModelValueList._next(this, nextList);

  @override
  String get fieldLabel => _fieldLabel;

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
