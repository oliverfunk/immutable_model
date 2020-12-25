import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../../model_type.dart';

class ModelList<V> extends ValidPrimitiveListType<ModelList<V>, V>
    with ModelType<ModelList<V>, List<V>> {
  final String _label;

  ModelList(
    List<V> initialList, {
    bool Function(List<V>)? validator,
    required String label,
  })   : _label = label,
        super.initial(
          initialList,
          validator: validator,
        );

  ModelList._next(ModelList<V> previous, List<V> nextList)
      : _label = previous._label,
        super.constructNext(previous, nextList);

  @override
  @protected
  ModelList<V> buildNext(List<V> nextList) => ModelList._next(this, nextList);

  @override
  String get label => _label;

  @override
  List serializer(List<V> currentList) {
    final sl = V == DateTime
        ? currentList.map((i) => (i as DateTime).toIso8601String())
            as Iterable<V>
        : currentList;
    return List.unmodifiable(sl);
  }

  @override
  List<V>? deserializer(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        final l = V == DateTime
            ? serialized.cast<String>().map(DateTime.parse) as Iterable<V>
            : serialized.cast<V>();
        return l.toList();
        // ignore: avoid_catching_errors
      } on TypeError {
        // cast failed
        return null;
      } on FormatException {
        return null;
      }
    } else {
      return null;
    }
  }
}
