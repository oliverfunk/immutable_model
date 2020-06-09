class ModelTypeException<T> implements Exception {
  final dynamic receivedValue;
  final String fieldName;

  ModelTypeException(this.receivedValue, [this.fieldName]);

  @override
  String toString() => "ModelTypeException${fieldName == null ? "" : " [for field '$fieldName']"}: Expected $T but received ${receivedValue.runtimeType} with value '$receivedValue'";
}

class ModelValidationException implements Exception {
  final dynamic receivedValue;
  final String fieldName;

  ModelValidationException(this.receivedValue, [this.fieldName]);

  @override
  String toString() => "ModelValidationException${fieldName == null ? "" : " [for field '$fieldName']"}: Validation failed on value '$receivedValue'";
}