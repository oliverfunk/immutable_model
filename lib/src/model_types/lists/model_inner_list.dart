part of 'model_list.dart';

/// A model for a list of [ModelInner]s.
class ModelInnerList extends ModelList<ModelInnerList, ModelInner> {
  /// The internal [ModelInner] model used by this class.
  final ModelInner _model;

  /// The [ModelInner] model.
  ModelInner get inner => _model;

  factory ModelInnerList.fromIM(
    ImmutableModel model, [
    List<Map<String, dynamic>> initialModelValues =
        const <Map<String, dynamic>>[],
  ]) =>
      ModelInnerList(
        model.inner,
        initialModelValues,
      );

  factory ModelInnerList(
    ModelInner innerModel, [
    List<Map<String, dynamic>> initialModelValues =
        const <Map<String, dynamic>>[],
  ]) {
    if (innerModel == null) {
      throw ModelInitializationError(
        ModelInnerList,
        "A model must be provided",
      );
    }
    return ModelInnerList._(
      innerModel,
      initialModelValues.map((i) => innerModel.nextWithUpdates(i)).toList(),
    );
  }

  ModelInnerList._(
    this._model,
    List<ModelInner> initialList,
  ) : super._(initialList, (i) => i.hasEqualityOfHistory(_model));

  ModelInnerList._next(ModelInnerList previous, BuiltList<ModelInner> nextList)
      : _model = previous._model,
        super._constructNext(previous, nextList);

  // always rebuild, possibly a very expensive call to check equality
  // of each ModelInner in the list each update.
  @override
  bool shouldBuild(List<ModelInner> nextList) => true;

  @override
  ModelInnerList buildNextInternal(BuiltList<ModelInner> nextList) =>
      ModelInnerList._next(this, nextList);

  @override
  List<Map<String, dynamic>> asSerializable() =>
      List.unmodifiable(value.map((i) => i.asSerializable()));

  @override
  List<ModelInner> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      try {
        return serialized
            .cast<Map<String, dynamic>>()
            .map(_model.nextWithSerialized)
            .toList();
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
