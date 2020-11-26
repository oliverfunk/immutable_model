import '../../typedefs.dart';
import '../model_value.dart';

/// A model for a validated [int].
class ModelInt extends ModelValue<ModelInt, int> {
  /// Constructs a [ModelValue] of an [int].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [int] value passed to it is valid and `false` otherwise.
  /// [validator] can be `null` indicating this model has no validation.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelInt(
    int initialValue, [
    ModelValueValidator<int> validator,
  ]) =>
      ModelInt._(initialValue, validator);

  ModelInt._(
    int initialValue,
    ModelValueValidator<int> validator,
  ) : super.int(initialValue, validator);

  ModelInt._next(ModelInt previous, int value)
      : super.constructNext(previous, value);

  @override
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);

  @override
  int asSerializable() => super.asSerializable();
}
