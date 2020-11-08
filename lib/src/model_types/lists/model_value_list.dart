part of 'model_list.dart';

class ModelValueList extends ModelList<ModelValueList, ModelValue> {
  /// The internal [ModelValue] model used by this class.
  final ModelValue _model;

  factory ModelValueList(
    ModelValue model,
    List initialModelValues, {
    String fieldLabel,
  }) {
    if (model == null) {
      throw ModelInitializationError(
        ModelValueList,
        "A model must be provided",
      );
    }
    return ModelValueList._(
      model,
      initialModelValues?.map((i) => model.next(i) as ModelValue)?.toList(),
      fieldLabel,
    );
  }

  ModelValueList._(
    this._model,
    List<ModelValue> initialList, [
    String fieldLabel,
  ]) : super._(
          initialList,
          (i) => i.hasEqualityOfHistory(_model),
          fieldLabel,
        );

  ModelValueList._next(ModelValueList previous, BuiltList<ModelValue> nextList)
      : _model = previous._model,
        super._constructNext(previous, nextList);

  @override
  ModelValueList buildNextInternal(BuiltList<ModelValue> next) =>
      ModelValueList._next(this, next);

  @override
  List asSerializable() =>
      List.unmodifiable(value.map((i) => i.asSerializable()));

  @override
  List<ModelValue> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      // if the item cannot be deserialized, an instance of the model passed in will be used
      return serialized
          .map((i) => _model.nextWithSerialized(i) as ModelValue)
          .toList();
    } else {
      return null;
    }
  }

  /// Returns the value of the model at [index]
  dynamic valueAt(int index) => itemAt(index).value;
}
