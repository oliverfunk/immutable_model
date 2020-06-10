import 'model_types/model_value.dart';

class ModelTypeException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelTypeException(this.model, this.receivedValue);

  @override
  String toString() => "ModelTypeException:\n"
      " For: ${model.toLongString()}\n"
      " Reason: Expected '${model.valueType}' but received '${receivedValue.runtimeType}' with value '$receivedValue'";
}

class ModelValidationException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelValidationException(this.model, this.receivedValue);

  @override
  String toString() => "ModelValidationException:\n"
      " For: ${model.toLongString()}\n"
      " Reason: Validation failed on value '$receivedValue'";
}

class ModelEqualityException implements Exception {
  final ModelValue model;
  final ModelValue receivedModel;

  ModelEqualityException(this.model, this.receivedModel);

  @override
  String toString() => "ModelEqualityException:\n"
      " For: ${model.toLongString()}\n"
      " Reason: Not the same as ${receivedModel.toLongString()} because their histories are not equal";
}

class ModelFromJsonException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ModelFromJsonException(this.model, this.receivedValue);

  @override
  String toString() => "ModelFromJsonException:\n"
      " For: ${model.toLongString()}\n"
      " Reason: Cannot convert '$receivedValue' to ${model.modelType}";
}
