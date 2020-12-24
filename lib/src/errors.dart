// import '../immutable_model.dart';
// import '../model_types.dart';
// import 'model_type.dart';

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

/// An [Error] that occurs when an attempt is made to update an [ImmutableModel]
/// with an update that was not strict.
class ModelStrictUpdateError extends Error {
  ModelStrictUpdateError();

  @override
  String toString() =>
      'ModelStrictUpdateError: Cannot update, the update is not strict.';
}

// /// An [Error] that occurs when an attempt is made to access a model that does not exist in a [potentially].
// class ModelAccessError extends Error {
//   final Iterable<String> labels;
//   final String field;

//   ModelAccessError(this.labels, this.field);

//   @override
//   String toString() => "ModelAccessError\n"
//       "'$field' not in model.\n"
//       " Available fields are: $labels";
// }

// /// An [Error] that occurs when an attempt is made to traverse a level of a state tree's hierarchy,
// /// but the selected model is not a [potentially].
// class ModelSelectError extends Error {
//   final String field;

//   ModelSelectError(this.field);

//   @override
//   String toString() => "ModelSelectError\n"
//       "Attempting to traverse the state tree but the selected '$field' is not a ModelInner.";
// }

/// An [Error] that occurs when an attempt is made to update an [ImmutableModel] but the it is in the incorrect state,
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
