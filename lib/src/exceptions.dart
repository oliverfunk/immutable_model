import '../model_types.dart';

abstract class ImmutableModelException implements Exception {
  final ModelType model;
  final String reason;

  ImmutableModelException(this.model, this.reason);

  @override
  String toString() => "${runtimeType} occurred for ${model.toShortString()}:\n$reason";
}

class ValidationException extends ImmutableModelException {
  ValidationException(ModelType model, dynamic receivedValue)
      : super(model, "Validation failed on value '$receivedValue'");
}

class StrictUpdateException extends ImmutableModelException {
  StrictUpdateException(ModelInner model, Map<String, dynamic> update)
      : super(
            model,
            "The update did not contain all fields in the model or some values were null\n"
            "  Fields in model:   ${model.fieldLabels}\n"
            "  Fields in update:  ${update.keys}");
}

class DeserialisationException extends ImmutableModelException {
  DeserialisationException(ModelType model, dynamic receivedValue)
      : super(model, "Could not deserialize value '$receivedValue'");
}
