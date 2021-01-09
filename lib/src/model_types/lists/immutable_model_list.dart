import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../../immutable_model/immutable_model.dart';
import '../../model_type.dart';
import '../model_inner.dart';

class ImmutableModelList<M extends ImmutableModel<M>>
    extends ValidValueListType<ImmutableModelList<M>, M>
    with ModelType<ImmutableModelList<M>, List<M>> {
  final String _label;

  ImmutableModelList(
    List<M> models, {
    required ModelInner<M> validator,
    required String label,
  })   : _label = label,
        super.initial(
          models,
          validator: validator,
        );

  ImmutableModelList._next(ImmutableModelList<M> previous, List<M> nextList)
      : _label = previous._label,
        super.constructNext(previous, nextList);

  @override
  @protected
  ImmutableModelList<M> buildNext(List<M> nextList) =>
      ImmutableModelList._next(this, nextList);

  @override
  String get label => _label;

  @override
  List serializer(List<M> currentList) => List.unmodifiable(
        currentList.map(
          (i) => (validator as ModelInner).serializer(i),
        ),
      );

  @override
  List<M>? deserializer(dynamic serialized) {
    if (serialized is Iterable) {
      final returnList = <M>[];
      // if isStrict is set to true and item is not s strict update,
      // the default value of validator will be used in place.
      for (var item in serialized) {
        final model = (validator as ModelInner<M>).deserializer(item);
        if (model == null) return null;
        returnList.add(model);
      }
      return returnList;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    var s = 'ImmutableModelList<$M>(';
    for (var model in internalList) {
      s += '\n${model.toIndentableString(1)}';
    }
    s += '\n)';
    return s;
  }
}
