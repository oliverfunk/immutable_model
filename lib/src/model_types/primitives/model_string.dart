import '../../model_type.dart';
import '../../model_value.dart';

/// A model for a validated [String].
class ModelString extends ModelValue<ModelString, String> {
  /// Constructs a [ModelValue] of a [String].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [String] value passed to it is valid and `false` otherwise.
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
  /// Throws a [ModelInitialValidationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelString(
    String initialValue, [
    ValueValidator<String> validator,
  ]) =>
      ModelString._(initialValue, validator);

  /// Constructs a [ModelValue] of a [String], where the underlying [String] cannot be null or empty.
  /// Additional validations may be specified.
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [String] value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitialValidationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelString.text(
    String initialValue, [
    ValueValidator<String> validator,
  ]) =>
      ModelString._text(initialValue, validator);

  ModelString._(
    String initialValue,
    ValueValidator<String> validator,
  ) : super.string(initialValue, validator);

  ModelString._text(
    String initialValue,
    ValueValidator<String> validator,
  ) : super.text(initialValue, validator);

  ModelString._next(ModelString previous, String value)
      : super.constructNext(previous, value);

  @override
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);

  @override
  String asSerializable() => super.asSerializable();
}
