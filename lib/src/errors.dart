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
  final ModelType requestedField;
  final List<ModelType> fields;

  ModelFieldSelectError(this.requestedField, this.fields);

  @override
  String toString() =>
      'ModelFieldSelectError: field "${requestedField.label}" not in model.'
      '\n Available Fields: ${fields.map((e) => e.label).toList()}';
}

/// An [Error] that occurs when an attempt is made to transition to
/// a state not allowed by the current state's
/// [ModelState.transitionableStates] property.
class ModelStateTransitionError extends Error {
  final ModelState currentState;
  final ModelState requestedState;

  ModelStateTransitionError(this.currentState, this.requestedState);

  @override
  String toString() =>
      'ModelStateTransitionError: The requested state cannot be transitioned to from the current state.\n'
      ' Requested state:      $requestedState\n'
      ' Current state:        $currentState\n'
      ' Allowed transitions:  ${currentState.transitionableStates}\n'
      ' Self transitions:     ${currentState.canSelfTransition}';
}

/// An [Error] that occurs when an attempt is made to update
/// an [ImmutableModel] but the it is in the incorrect state,
/// as required by the update.
class ModelInStateError extends Error {
  final dynamic currentState;
  final dynamic requiredState;

  ModelInStateError(this.currentState, this.requiredState);

  @override
  String toString() =>
      'ModelInStateError: The model is in an incorrect state and cannot update.\n'
      ' Current state:  ${currentState.runtimeType}\n'
      ' Required state: ${requiredState.runtimeType}';
}
