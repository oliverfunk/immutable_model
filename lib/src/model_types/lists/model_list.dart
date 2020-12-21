import 'package:valid/valid.dart';

import '../../serializable_valid_type.dart';

class ModelList<V> extends ValidPrimitiveListType<ModelList<V>, V>
    with SerializableValidType<ModelList<V>, List<V>> {
  final String _fieldLabel;

  ModelList(
    this._fieldLabel, [
    List<V> initialList = const [],
    bool Function(List<V>)? listValidator,
  ]) : super.initial(initialList, listValidator);

  ModelList._next(ModelList<V> previous, List<V> nextList)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextList);

  @override
  ModelList<V> buildNext(List<V> nextList) => ModelList._next(this, nextList);

  @override
  String get fieldLabel => _fieldLabel;

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
      }
    } else {
      return null;
    }
  }
}
