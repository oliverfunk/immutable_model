import 'package:immutable_model/model_types.dart';

import 'model_value.dart';

String _eStr<E>({ModelValue modelFor, String reason}) => "$E\n"
    "  For:    ${modelFor.toLongString()}\n"
    "  Reason: $reason";

class ImmutableModelTypeException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ImmutableModelTypeException(this.model, this.receivedValue);

  @override
  String toString() => _eStr<ImmutableModelTypeException>(
      modelFor: model,
      reason:
          "Expected type <${model.valueType}> but received <${receivedValue.runtimeType}> with value '$receivedValue'");
}

class ImmutableModelValidationException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ImmutableModelValidationException(this.model, this.receivedValue);

  @override
  String toString() =>
      _eStr<ImmutableModelValidationException>(modelFor: model, reason: "Validation failed on value '$receivedValue'");
}

class ImmutableModelEqualityException implements Exception {
  final ModelValue model;
  final ModelValue receivedModel;

  ImmutableModelEqualityException(this.model, this.receivedModel);

  @override
  String toString() => _eStr<ImmutableModelEqualityException>(
      modelFor: model, reason: "No equality of history with ${receivedModel.toLongString()}");
}

class ImmutableModelUpdateException implements Exception {
  final ModelValue model;
  final dynamic received;
  final String reason;

  ImmutableModelUpdateException(this.model, this.received, this.reason);

  @override
  String toString() => _eStr<ImmutableModelEqualityException>(
      modelFor: model, reason: "Could not update this model with: ${received}.\n$reason");
}

class ImmutableModelAccessException implements Exception {
  final ModelInner model;
  final String field;

  ImmutableModelAccessException(this.model, this.field);

  @override
  String toString() => _eStr<ImmutableModelAccessException>(
      modelFor: model, reason: "Requested field '$field' not in model. Available fields are: ${model.fields}");
}

class ImmutableModelDeserialisationException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ImmutableModelDeserialisationException(this.model, this.receivedValue);

  @override
  String toString() =>
      _eStr<ImmutableModelDeserialisationException>(modelFor: model, reason: "Cannot desearilse '$receivedValue'}>");
}
