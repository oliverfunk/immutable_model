import '../immutable_model.dart';
import '../model_types.dart';
import 'model_type.dart';

/// An [Error] that occurs when a model is being initialized with a value that does not validated.
class ModelInitializationError extends Error {
  final ModelType thisModel;
  final dynamic receivedValue;

  ModelInitializationError(this.thisModel, this.receivedValue);

  @override
  String toString() => "ModelInitializationError\n"
      "Attempting to initialize model <${thisModel.modelType}> with invalid data.\n"
      " This model:     ${thisModel.toLongString()}\n"
      " Invalid data:   $receivedValue";
}

/// An [Error] that occurs when a model is being updated with a value that does not match the model's [ModelType.valueType].
class ModelTypeError extends Error {
  final ModelType thisModel;
  final dynamic receivedValue;

  ModelTypeError(this.thisModel, this.receivedValue);

  @override
  String toString() => "ModelTypeError\n"
      "Expected type <${thisModel.valueType}> but received <${receivedValue.runtimeType}>.\n"
      " This model:     ${thisModel.toLongString()}\n"
      " Received value: $receivedValue";
}

/// An [Error] that occurs when a model is being updated with another model that does not share a history with it.
///
/// See [ModelType.hasEqualityOfHistory].
class ModelHistoryEqualityError extends Error {
  final ModelType thisModel;
  final ModelType receivedModel;

  ModelHistoryEqualityError(this.thisModel, this.receivedModel);

  @override
  String toString() => "ModelHistoryEqualityError\n"
      "The models have no shared history.\n"
      " This model:     ${thisModel.toLongString()}\n"
      " Received model: ${receivedModel.toLongString()}";
}

/// An [Error] that occurs when an attempt is made to access a model that does not exist in a [ModelInner].
class ModelAccessError extends Error {
  final ModelInner model;
  final String field;

  ModelAccessError(this.model, this.field);

  @override
  String toString() => "ModelAccessError\n"
      "Requested field '$field' not in model.\n"
      " Available fields are: ${model.fieldLabels}";
}

/// An [Error] that occurs when an attempt is made to traverse a level of a state tree's hierarchy,
/// but the selected model is not a [ModelInner].
class ModelSelectError extends Error {
  final String field;

  ModelSelectError(this.field);

  @override
  String toString() => "ModelSelectError\n"
      "Attempting to traverse the state tree but the selected '$field' is not a ModelInner.";
}

/// An [Error] that occurs when an attempt is made to update an [ImmutableModel] but the it is in the incorrect state,
/// as required by the update.
class ModelStateError extends Error {
  final dynamic currentState;
  final dynamic requiredState;

  ModelStateError(this.currentState, this.requiredState);

  @override
  String toString() => "ModelStateError\n"
      "The model is in an incorrect state and cannot update.\n"
      " Current state:  ${currentState.runtimeType}\n"
      " Required state: ${requiredState.runtimeType}";
}
