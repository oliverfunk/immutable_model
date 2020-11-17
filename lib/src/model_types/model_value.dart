import '../model_type.dart';
import '../typedefs.dart';

/// An abstract class for a [ModelType] that holds, directly,
/// a value [V] instead of a some underlying data structure.
///
/// Supported [V] are:
///
/// - [bool]
/// - [int]
/// - [double]
/// - [String]
/// - [DateTime]
///
/// When extending this class with the intent to define a validated value type,
/// the [ValueType] mixin should be used `with` the sub-class.
abstract class ModelValue<M extends ModelValue<M, V>, V>
    extends ModelType<M, V> {
  /// The wrapped value
  final V _current;

  @override
  V get value => _current;

  @override
  dynamic asSerializable() => value;

  @override
  V deserialize(dynamic serialized) => serialized is V ? serialized : null;

  /// A constructor for an object that models an [bool].
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// This model needs no validation.
  ModelValue.bool(
    // ignore: avoid_positional_boolean_parameters
    bool initialValue,
  ) : this._(initialValue as V, null);

  /// A constructor for an object that models an [int].
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// [validator] is a function that must return `true` if the value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  ModelValue.int(
    int initialValue,
    ValueValidator<int> validator,
  ) : this._(initialValue as V, validator as ValueValidator<V>);

  /// A constructor for an object that models a [double].
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// [validator] is a function that must return `true` if the value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  ModelValue.double(
    double initialValue,
    ValueValidator<double> validator,
  ) : this._(initialValue as V, validator as ValueValidator<V>);

  /// A constructor for an object that models a [String].
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// [validator] is a function that must return `true` if the value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  ModelValue.string(
    String initialValue,
    ValueValidator<String> validator,
  ) : this._(initialValue as V, validator as ValueValidator<V>);

  /// A constructor for an object that models a [String], where the String cannot be null or empty.
  /// Additional validations may be specified.
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// [validator] is a function that must return `true` if the value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  ModelValue.text(
    String initialValue,
    ValueValidator<String> validator,
  ) : this._(
            initialValue as V,
            validator == null
                ? (str) => str != null && (str as String).isNotEmpty
                : (str) =>
                    str != null &&
                    (str as String).isNotEmpty &&
                    validator(str as String));

  /// A constructor for an object that models a [DateTime].
  ///
  /// [initialValue] defines the initial value for this model.
  /// A `null` value indicates the model has no initial value.
  ///
  /// [validator] is a function that must return `true` if the value passed to it is valid and `false` otherwise.
  ///
  /// [validator] will be run on every update ([next] etc.) to this model.
  /// If it returns `true`, the update will be applied otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// [validator] will be run on [initialValue] if they are both not null.
  ///
  /// Throws a [ModelInitializationError] if [validator] returns `false` after being run on [initialValue].
  ModelValue.datetime(
    DateTime initialValue,
    ValueValidator<DateTime> validator,
  ) : this._(initialValue as V, validator as ValueValidator<V>);

  ModelValue._(this._current, ValueValidator<V> validator)
      : super.initial(_current, validator);

  ModelValue.constructNext(M previous, this._current)
      : super.fromPrevious(previous);
}

/// A mixin that provides the relevant overrides when defining a value type class that wraps its own validation.
///
/// These overrides ensure that any instance of this value type can be used to update the value of
/// previous instance to its value. Otherwise, only instances that share a *direct* history with a previous one may do so.
///
/// This may be done because the class that uses this mixin wraps its own validation,
/// therefore all instances of it will hold an equally valid value and thus all "share a history" in an abstract sense.
mixin ValueType<M extends ModelValue<M, V>, V> on ModelValue<M, V> {
  @override
  M buildFromModel(M previous) => identical(initial, previous.initial)
      ? previous
      : buildNext(previous.value);

  @override
  bool hasEqualityOfHistory(ModelType other) => other is M;
}
