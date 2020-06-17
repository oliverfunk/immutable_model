import 'model_types/model_value.dart';

String _eStr<E>({ModelValue modelFor, String reason}) => "$E\n"
    "  For:    ${modelFor.toLongString()}\n"
    "  Reason: $reason";

class ModelTypeException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelTypeException(this.model, this.receivedValue);

  @override
  String toString() => _eStr<ModelTypeException>(
      modelFor: model,
      reason:
          "Expected type <${model.valueType}> but received <${receivedValue.runtimeType}> with value '$receivedValue'");
}

class ModelValidationException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelValidationException(this.model, this.receivedValue);

  @override
  String toString() => _eStr<ModelValidationException>(
      modelFor: model, reason: "Validation failed on value '$receivedValue'");
}

class ModelEqualityException implements Exception {
  final ModelValue model;
  final ModelValue receivedModel;

  ModelEqualityException(this.model, this.receivedModel);

  @override
  String toString() => _eStr<ModelEqualityException>(
      modelFor: model,
      reason:
          "Not the same as ${receivedModel.toLongString()} because their histories are not equal");
}

class ModelFromJsonException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelFromJsonException(this.model, this.receivedValue);

  @override
  String toString() => _eStr<ModelFromJsonException>(
      modelFor: model,
      reason: "Cannot convert '$receivedValue' to <${model.modelType}>");
}

class ModelInitialisationError extends Error {
  final String reason;

  ModelInitialisationError(this.reason);

  @override
  String toString() => "ModelInitialisationError\n"
      "  $reason";
}
