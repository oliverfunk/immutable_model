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

class ImmutableModelDeserialisationException implements Exception {
  final ModelValue model;
  final dynamic receivedValue;

  ImmutableModelDeserialisationException(this.model, this.receivedValue);

  @override
  String toString() =>
      _eStr<ImmutableModelDeserialisationException>(modelFor: model, reason: "Cannot desearilse '$receivedValue'}>");
}

class ImmutableModelStructureException implements Exception {
  final Iterable modelKeys;
  final Iterable receivedKeys;

  ImmutableModelStructureException(this.modelKeys, this.receivedKeys);

  @override
  String toString() => "ModelStructuralException\n"
      "  Reason: Some fields not in model\n"
      "   Model fields:     $modelKeys\n"
      "   Recievied fields: $receivedKeys";
}
