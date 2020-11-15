import '../../model_value.dart';

/// A model for a [bool]. This class needs no validator.
class ModelBool extends ModelValue<ModelBool, bool> {
  /// Constructs a [ModelValue] of a [bool].
  ///
  /// [initialValue] defines the first (or default) value.
  /// This can be accessed using the [initialValue] instance, useful when resetting.
  /// [initialValue] can be `null` indicating this model has no initial (or default) value.
  ///
  /// This model needs no validation.
  ///
  /// [fieldLabel] should be the [String] associated with this model when used in a [ModelInner] or [ImmutableModel].
  /// This is not guaranteed, however.
  factory ModelBool(
    // ignore: avoid_positional_boolean_parameters
    bool initialValue,
  ) =>
      ModelBool._(initialValue);

  ModelBool._(
    bool initialValue,
  ) : super.bool(initialValue);

  ModelBool._next(ModelBool previous, bool value)
      : super.constructNext(previous, value);

  @override
  ModelBool buildNext(bool nextValue) => ModelBool._next(this, nextValue);

  @override
  bool asSerializable() => super.asSerializable();
}
