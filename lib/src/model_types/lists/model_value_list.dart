part of 'model_list.dart';

class ModelValueList<M extends ModelValue<M, dynamic>>
    extends ModelList<ModelValueList<M>, M> {
  /// The internal [ModelValue] model used by this class.
  final M _model;

  M get model => _model;

  factory ModelValueList(
    M defaultModel,
    List initialModelValues, {
    String fieldLabel,
  }) {
    if (defaultModel == null) {
      throw ModelInitializationError(
        ModelValueList,
        "A model must be provided",
      );
    }
    return ModelValueList._(
      defaultModel,
      initialModelValues?.map((i) => defaultModel.next(i))?.toList(),
      fieldLabel,
    );
  }

  factory ModelValueList.numberOfDefault(
    M defaultModel,
    int numberOfDefault, {
    String fieldLabel,
  }) {
    if (defaultModel == null) {
      throw ModelInitializationError(
        ModelValueList,
        "A model must be provided",
      );
    }
    return ModelValueList._(
      defaultModel,
      List(numberOfDefault)
        ..fillRange(0, numberOfDefault, defaultModel.initial),
      fieldLabel,
    );
  }

  ModelValueList._(
    this._model,
    List<M> initialList, [
    String fieldLabel,
  ]) : super._(
          initialList,
          (i) => i.hasEqualityOfHistory(_model),
          fieldLabel,
        );

  ModelValueList._next(
    ModelValueList<M> previous,
    BuiltList<M> nextList,
  )   : _model = previous._model,
        super._constructNext(previous, nextList);

  @override
  ModelValueList<M> buildNextInternal(BuiltList<M> next) =>
      ModelValueList<M>._next(this, next);

  @override
  List asSerializable() =>
      List.unmodifiable(value.map((i) => i.asSerializable()));

  @override
  List<M> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      // if the item cannot be deserialized, an instance of the model passed in will be used
      return serialized.map(_model.nextWithSerialized).toList();
    } else {
      return null;
    }
  }

  /// The list of values of [M].
  ///
  /// Note: this is a mutable copy
  List get valueList => value.map((i) => i.value).toList();

  /// Returns the value of the model at [index]
  dynamic valueAt(int index) => itemAt(index).value;
}
