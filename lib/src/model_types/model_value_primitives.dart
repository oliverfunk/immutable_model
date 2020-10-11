import '../model_type.dart';
import '../model_value.dart';

/// A model for a [bool]. This class needs no validator.
class ModelBool extends ModelValue<ModelBool, bool> {
  ModelBool._([
    bool initialValue,
    String fieldLabel,
  ]) : super.bool(initialValue, fieldLabel);

  ModelBool._next(ModelBool previous, bool value)
      : super.constructNext(previous, value);

  /// Constructs a [ModelValue] of a [bool].
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelBool({
    bool initial,
    String fieldLabel,
  }) =>
      ModelBool._(initial, fieldLabel);

  @override
  ModelBool buildNext(bool nextValue) => ModelBool._next(this, nextValue);
}

/// A model for a validated [int].
class ModelInt extends ModelValue<ModelInt, int> {
  ModelInt._([
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  ]) : super.int(initialValue, validator, fieldLabel);

  ModelInt._next(ModelInt previous, int value)
      : super.constructNext(previous, value);

  /// Constructs a [ModelValue] of an [int].
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [int] value passed to it is valid and `false` otherwise.
  /// [validator] can be `null` indicating this model has no validation.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [validator] will be run on [initial] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initial].
  factory ModelInt({
    int initial,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt._(initial, validator, fieldLabel);

  @override
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);
}

/// A model for a validated [double].
class ModelDouble extends ModelValue<ModelDouble, double> {
  ModelDouble._([
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  ]) : super.double(initialValue, validator, fieldLabel);

  ModelDouble._next(ModelDouble previous, double value)
      : super.constructNext(previous, value);

  /// Constructs a [ModelValue] of a [double].
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
  ///
  /// [validator] is a function that must return `true` if the [double] value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [validator] will be run on [initial] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initial].
  factory ModelDouble({
    double initial,
    ValueValidator<double> validator,
    String fieldLabel,
  }) =>
      ModelDouble._(initial, validator, fieldLabel);

  @override
  ModelDouble buildNext(double nextValue) => ModelDouble._next(this, nextValue);
}

/// A model for a validated [String].
class ModelString extends ModelValue<ModelString, String> {
  ModelString._([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ]) : super.string(initialValue, validator, fieldLabel);

  ModelString._text([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ]) : super.text(initialValue, validator, fieldLabel);

  ModelString._next(ModelString previous, String value)
      : super.constructNext(previous, value);

  /// Constructs a [ModelValue] of a [String].
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
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
  /// [validator] will be run on [initial] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initial].
  factory ModelString({
    String initial,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString._(initial, validator, fieldLabel);

  /// Constructs a [ModelValue] of a [String], where the underlying [String] cannot be null or empty.
  /// Additional validations may be specified.
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
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
  /// [validator] will be run on [initial] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initial].
  factory ModelString.text({
    String initial,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString._text(initial, validator, fieldLabel);

  @override
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);
}

/// A model for a validated [DateTime]
class ModelDateTime extends ModelValue<ModelDateTime, DateTime> {
  ModelDateTime._([
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ]) : super.datetime(initialValue, validator, fieldLabel);

  ModelDateTime._next(ModelDateTime previous, DateTime value)
      : super.constructNext(previous, value);

  /// Constructs a [ModelValue] of a [DateTime].
  ///
  /// The underlying [DateTime] object is serialized using [DateTime.toIso8601String]
  /// and deserialized using [DateTime.parse].
  ///
  /// [initial] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initial] can be `null` indicating this model has no initial (or default) value.
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
  /// [validator] will be run on [initial] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initial].
  factory ModelDateTime({
    DateTime initial,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime._(initial, validator, fieldLabel);

  @override
  ModelDateTime buildNext(DateTime nextValue) =>
      ModelDateTime._next(this, nextValue);

  @override
  String asSerializable() => value.toIso8601String();

  @override
  DateTime fromSerialized(dynamic serialized) =>
      serialized is String ? DateTime.parse(serialized) : null;
}
