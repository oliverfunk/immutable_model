import '../model_types.dart';

/// The abstract [Exception] used for model exceptions
abstract class ModelException implements Exception {
  final Type modelType;
  final String reason;
  final String fieldLabel;

  ModelException(
    this.modelType,
    this.reason, [
    this.fieldLabel,
  ]);

  @override
  String toString() => "$runtimeType occurred for $modelType:\n"
      " $reason\n"
      " ${fieldLabel == null ? '' : 'For: $fieldLabel\n'}";
}

/// An [Exception] that occurs when a model is updated with an invalid value.
class ModelValidationException extends ModelException {
  ModelValidationException(
    Type modelType,
    dynamic receivedValue, [
    String fieldLabel,
  ]) : super(
          modelType,
          "Validation failed on '$receivedValue'",
        );
}

/// An [Exception] that occurs when a [ModelInner] is updated with a map that fails a [ModelInner.strictUpdates] check.
class ModelStrictUpdateException extends ModelException {
  ModelStrictUpdateException(
      ModelInner currentModel, Map<String, dynamic> update)
      : super(
          ModelInner,
          "The update did not contain all fields in the model or some values were null\n"
          "  Fields in model:   ${currentModel.fieldLabels}\n"
          "  Fields in update:  ${update.keys}",
          currentModel.fieldLabel,
        );
}

/// An [Exception] that occurs when a value cannot be deserialized using a model's [ModelType.deserialize] method.
class ModelDeserializationException extends ModelException {
  ModelDeserializationException(
    Type modelType,
    dynamic receivedValue, [
    String fieldLabel,
  ]) : super(
          modelType,
          "Could not deserialize value '$receivedValue'",
          fieldLabel,
        );
}
