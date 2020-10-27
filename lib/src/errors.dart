import '../immutable_model.dart';
import '../model_types.dart';
import 'model_type.dart';

/// An [Error] that occurs during the initialization of a model.
class ModelInitializationError extends Error {
  final Type modelType;
  final String message;

  ModelInitializationError(this.modelType, this.message);

  @override
  String toString() => "ModelInitializationError\n"
      "An error occurred during the initialization of a model:\n"
      " Model:  $modelType\n"
      " Reason: $message";
}

/// An [Error] that occurs when a model is being initialized with a value that does not validated.
class ModelInitialValidationError extends Error {
  final Type modelType;
  final dynamic receivedValue;

  ModelInitialValidationError(this.modelType, this.receivedValue);

  @override
  String toString() => "ModelInitialValidationError\n"
      "Attempting to initialize a model with invalid data:\n"
      " Model:    $modelType\n"
      " Received: $receivedValue";
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

/// An [Error] that occurs when an [EnumModel] is updated
/// with a string that does not match any of the internal enums.
class ModelEnumError extends Error {
  final ModelEnum modelEnum;
  final String receivedValue;

  ModelEnumError(this.modelEnum, this.receivedValue);

  @override
  String toString() => "ModelEnumError\n"
      "$receivedValue does not match an enum in the model\n"
      " Model:            ${modelEnum.toLongString()}\n"
      " Available enums:  ${modelEnum.enumStrings}\n";
}

/// An [Error] that occurs when an attempt is made to update a [ModelInner]
/// with a selector when that [ModelInner] can only be updated strictly.
class ModelInnerStrictUpdateError extends Error {
  ModelInnerStrictUpdateError();

  @override
  String toString() => "ModelInnerStrictUpdateError\n"
      " Cannot update this ModelInner with a selector when strictUpdates are enabled.";
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
  final Iterable<String> fieldLabels;
  final String field;

  ModelAccessError(this.fieldLabels, this.field);

  @override
  String toString() => "ModelAccessError\n"
      "'$field' not in model.\n"
      " Available fields are: $fieldLabels";
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
