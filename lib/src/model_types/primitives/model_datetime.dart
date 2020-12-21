import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [DateTime]
class ModelDateTime extends ModelValueType<ModelDateTime, DateTime> {
  ModelDateTime(
    String fieldLabel,
    DateTime initialValue, [
    Validator<DateTime>? validator,
  ]) : super.initial(fieldLabel, initialValue, validator);

  ModelDateTime._next(ModelDateTime previous, DateTime nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelDateTime buildNext(DateTime nextValue) =>
      ModelDateTime._next(this, nextValue);

  @override
  String serializer(DateTime currentValue) => currentValue.toIso8601String();

  @override
  DateTime? deserializer(dynamic serialized) {
    if (serialized is String) {
      try {
        final dt = DateTime.parse(serialized);
        return dt;
      } on FormatException {
        return null;
      }
    }
    return null;
  }
}
