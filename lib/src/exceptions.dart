import '../model_types.dart';

abstract class ImmutableModelException implements Exception {
  final ModelValue model;
  final String reason;

  ImmutableModelException(this.model, this.reason);

  @override
  String toString() => "${this.runtimeType} occured for ${model.toLongString()}: $reason";
}

class ValidationException extends ImmutableModelException {
  ValidationException(ModelValue model, dynamic receivedValue)
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
  DeserialisationException(ModelValue model, dynamic receivedValue)
      : super(model, "Could not deserialise value '$receivedValue'");
}

// class ImmutableModelUpdateException implements Exception {
//   final ModelValue model;
//   final dynamic received;
//   final String reason;

//   ImmutableModelUpdateException(this.model, this.received, this.reason);

//   @override
//   String toString() => _eStr<ImmutableModelUpdateException>(
//       modelFor: model, reason: "Could not update this model with: ${received}.\n$reason");
// }

// class ImmutableModelDeserialisationException implements Exception {
//   final ModelValue model;
//   final dynamic receivedValue;

//   ImmutableModelDeserialisationException(this.model, this.receivedValue);

//   @override
//   String toString() =>
//       _eStr<ImmutableModelDeserialisationException>(modelFor: model, reason: "Cannot desearilse '$receivedValue'}>");
// }
