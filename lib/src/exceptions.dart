import '../model_types.dart';

abstract class ImmutableModelException implements Exception {
  final ModelType model;
  final String reason;

  ImmutableModelException(this.model, this.reason);

  @override
  String toString() => "${this.runtimeType} occured for ${model.modelType}: $reason";
}

class ValidationException extends ImmutableModelException {
  ValidationException(ModelType model, dynamic receivedValue)
      : super(model, "Validation failed on value '$receivedValue'");
}

class StrictUpdateException extends ImmutableModelException {
  StrictUpdateException(ModelInner model, Map<String, dynamic> update)
      : super(
            model,
            "Some fields in model were not in the update or their value was null\n"
            "  Fields in model:   ${model.fieldLabels}\n"
            "  Fields in update:  ${update.keys}");
}

class DeserialisationException extends ImmutableModelException {
  DeserialisationException(ModelType model, dynamic receivedValue)
      : super(model, "Could not deserialise value '$receivedValue'");
}
