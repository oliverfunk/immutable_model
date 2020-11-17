import 'package:built_collection/built_collection.dart';

import '../../errors.dart';
import '../model_list.dart';
import '../model_value.dart';

class ModelValueList<M extends ModelValue<M, dynamic>>
    extends ModelList<ModelValueList<M>, M> {
  /// The internal [ModelValue] model used by this class.
  final M _model;

  M get defaultModel => _model;

  factory ModelValueList(
    M defaultModel, [
    List initialModelValues = const [],
  ]) {
    if (defaultModel == null) {
      throw ModelInitializationError(
        ModelValueList,
        "A model must be provided",
      );
    }
    return ModelValueList._(
      defaultModel,
      initialModelValues.map((i) => defaultModel.next(i)).toList(),
    );
  }

  factory ModelValueList.numberOfDefault(
    M defaultModel,
    int numberOfDefault,
  ) {
    if (defaultModel == null) {
      throw ModelInitializationError(
        ModelValueList,
        "A model must be provided",
      );
    }
    if (numberOfDefault < 1) {
      throw ModelInitializationError(
        ModelValueList,
        "numberOfDefault must be 1 or more",
      );
    }
    return ModelValueList._(
      defaultModel,
      List<M>(numberOfDefault)..fillRange(0, numberOfDefault, defaultModel),
    );
  }

  ModelValueList._(
    this._model,
    List<M> initialList,
  ) : super(initialList, (i) => i.hasEqualityOfHistory(_model));

  ModelValueList._next(
    ModelValueList<M> previous,
    BuiltList<M> nextList,
  )   : _model = previous._model,
        super.constructNext(previous, nextList);

  @override
  ModelValueList<M> buildNextInternal(BuiltList<M> next) =>
      ModelValueList<M>._next(this, next);

  @override
  List asSerializable() =>
      List.unmodifiable(value.map((i) => i.asSerializable()));

  @override
  List<M> deserialize(dynamic serialized) {
    if (serialized is Iterable) {
      // if an item in serialized cannot be deserialized,
      // an instance of the default model will be used
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
