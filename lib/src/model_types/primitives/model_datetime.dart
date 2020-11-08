import '../../model_type.dart';
import '../../model_value.dart';

/// A model for a validated [DateTime]
class ModelDateTime extends ModelValue<ModelDateTime, DateTime> {
  /// Constructs a [ModelValue] of a [DateTime].
  ///
  /// The underlying [DateTime] object is serialized using [DateTime.toIso8601String]
  /// and deserialized using [DateTime.parse].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [DateTime] value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelDateTime(
    DateTime initialValue, {
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime._(initialValue, validator, fieldLabel);

  ModelDateTime._(
    DateTime initialValue, [
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ]) : super.datetime(initialValue, validator, fieldLabel);

  ModelDateTime._next(ModelDateTime previous, DateTime value)
      : super.constructNext(previous, value);

  @override
  ModelDateTime buildNext(DateTime nextValue) =>
      ModelDateTime._next(this, nextValue);

  @override
  String asSerializable() => value.toIso8601String();

  @override
  DateTime deserialize(dynamic serialized) {
    if (serialized is String) {
      try {
        return DateTime.parse(serialized);
      } on FormatException {
        return null;
      }
    } else {
      return null;
    }
  }
}
