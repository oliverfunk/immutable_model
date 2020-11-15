import '../../model_type.dart';
import '../../model_value.dart';

/// A model for a validated [double].
class ModelDouble extends ModelValue<ModelDouble, double> {
  /// Constructs a [ModelValue] of a [double].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [double] value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelDouble(
    double initialValue, [
    ValueValidator<double> validator,
  ]) =>
      ModelDouble._(initialValue, validator);

  ModelDouble._(
    double initialValue,
    ValueValidator<double> validator,
  ) : super.double(initialValue, validator);

  ModelDouble._next(ModelDouble previous, double value)
      : super.constructNext(previous, value);

  @override
  ModelDouble buildNext(double nextValue) => ModelDouble._next(this, nextValue);

  @override
  double asSerializable() => super.asSerializable();
}
