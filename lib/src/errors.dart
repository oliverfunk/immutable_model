import '../immutable_model.dart';

/// An [Error] that occurs during the initialization of a model.
class ModelInitializationError extends Error {
  final Type imModel;

  ModelInitializationError(this.imModel);

  @override
  String toString() =>
      'ModelInitializationError: Attempting to initialize a model with invalid data'
      '\nCheck the model\'s validator function to make sure the initial field values validate.'
      '\n For: $imModel';
}

/// An [Error] that occurs when an attempt is made to update
/// an [ImmutableModel] with an update that was not strict.
class ModelStrictUpdateError extends Error {
  ModelStrictUpdateError();

  @override
  String toString() =>
      'ModelStrictUpdateError: Cannot update, the update is not strict.';
}

/// An [Error] that occurs when an attempt is made to update
/// an [ImmutableModel] with an update that was not strict.
class ModelFieldSelectError extends Error {
  final ModelType reqField;
  final List<ModelType> fields;

  ModelFieldSelectError(this.reqField, this.fields);

  @override
  String toString() =>
      'ModelFieldSelectError: the request field does not match a field instance in the model.'
      '\n Requested field:  $reqField'
      '\n Available Fields: $fields';
}

/// An [Error] that occurs when an attempt is made to update
/// an [ImmutableModel] but the it is in the incorrect state,
/// as required by the update.
class ModelStateError extends Error {
  final dynamic currentState;
  final dynamic requiredState;

  ModelStateError(this.currentState, this.requiredState);

  @override
  String toString() =>
      'ModelStateError: The model is in an incorrect state and cannot update.\n'
      ' Current state:  ${currentState.runtimeType}\n'
      ' Required state: ${requiredState.runtimeType}';
}
