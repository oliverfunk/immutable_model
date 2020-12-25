import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../model_enum.dart';
import '../../model_type.dart';

class ModelEnumList<E> extends ValidValueListType<ModelEnumList<E>, E>
    with ModelType<ModelEnumList<E>, List<E>> {
  final String _label;

  ModelEnumList(
    List<E> initialEnums, {
    required ModelEnum<E> validator,
    required String label,
  })   : _label = label,
        super.initial(
          initialEnums,
          validator: validator,
        );

  ModelEnumList._next(ModelEnumList<E> previous, List<E> nextList)
      : _label = previous._label,
        super.constructNext(previous, nextList);

  @override
  @protected
  ModelEnumList<E> buildNext(List<E> nextList) =>
      ModelEnumList._next(this, nextList);

  @override
  String get label => _label;

  @override
  List<String> serializer(List<E> currentList) => List.unmodifiable(
        currentList.map(
          (i) => (validator as ModelEnum<E>).serializer(i),
        ),
      );

  @override
  List<E>? deserializer(dynamic serialized) {
    if (serialized is Iterable) {
      final returnList = <E>[];
      for (var item in serialized) {
        final en = (validator as ModelEnum<E>).deserializer(item);
        if (en == null) return null;
        returnList.add(en);
      }
    } else {
      return null;
    }
  }
}
