import '../model_type.dart';
import '../model_value.dart';

/// A model for a [bool]. This class needs no validator.
class ModelBool extends ModelValue<ModelBool, bool> {
  ModelBool._([
    bool initialValue,
    String fieldLabel,
  ]) : super.bool(initialValue, fieldLabel);

  /// Constructs a [ModelValue] of a [bool].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelBool([bool initialValue, String fieldLabel]) => ModelBool._(initialValue, fieldLabel);

  ModelBool._next(ModelBool previous, bool value) : super.constructNext(previous, value);

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

  /// Constructs a [ModelValue] of an [int].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
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
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelInt([int initialValue, ValueValidator<int> validator, String fieldLabel]) =>
      ModelInt._(initialValue, validator, fieldLabel);

  ModelInt._next(ModelInt previous, int value) : super.constructNext(previous, value);

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

  /// Constructs a [ModelValue] of a [double].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
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
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelDouble([double initialValue, ValueValidator<double> validator, String fieldLabel]) =>
      ModelDouble._(initialValue, validator, fieldLabel);

  ModelDouble._next(ModelDouble previous, double value) : super.constructNext(previous, value);

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

  /// Constructs a [ModelValue] of a [String].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
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
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelString([String initialValue, ValueValidator<String> validator, String fieldLabel]) =>
      ModelString._(initialValue, validator, fieldLabel);

  /// Constructs a [ModelValue] of a [String], where the underlying [String] cannot be null or empty.
  /// Additional validations may be specified.
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
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
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  factory ModelString.text([String initialValue, ValueValidator<String> validator, String fieldLabel]) =>
      ModelString._text(initialValue, validator, fieldLabel);

  ModelString._next(ModelString previous, String value) : super.constructNext(previous, value);

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

  /// Constructs a [ModelValue] of a [DateTime].
  ///
  /// The underlying [DateTime] object is serialized using [DateTime.toIso8601String]
  /// and deserialized using [DateTime.parse].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initial] instance, useful when resetting.
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
  factory ModelDateTime([DateTime initialValue, ValueValidator<DateTime> validator, String fieldLabel]) =>
      ModelDateTime._(initialValue, validator, fieldLabel);

  ModelDateTime._next(ModelDateTime previous, DateTime value) : super.constructNext(previous, value);

  @override
  ModelDateTime buildNext(DateTime nextValue) => ModelDateTime._next(this, nextValue);

  @override
  String asSerializable() => value.toIso8601String();

  @override
  DateTime fromSerialized(dynamic serialized) => serialized is String ? DateTime.parse(serialized) : null;
}
