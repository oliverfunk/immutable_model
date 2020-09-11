import '../model_types.dart';
import 'model_type.dart';

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

class ModelAccessError extends Error {
  final ModelInner model;
  final String field;

  ModelAccessError(this.model, this.field);

  @override
  String toString() => "ModelAccessError\n"
      "Requested field '$field' not in model. Available fields are:\n"
      " ${model.fieldLabels}";
}

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
