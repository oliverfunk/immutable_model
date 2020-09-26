import '../model_types.dart';
import '../value_types.dart';

/// An abstract holding class defining shorthands for the constructors of each model defined in this library.
///
/// These contractions are useful in keeping definitions of [ImmutableModel]'s concise.
///
/// Meanings:
///
/// - `enm`: Enum
/// - `bl`: Boolean
/// - `nt`: Integer
/// - `dbl`: Double
/// - `dt`: DateTime
/// - `str`: String
/// - `txt`: Text
/// - `mv`: "Model Validated"
abstract class M {
  // model types

  /// Returns a [ModelInner].
  ///
  /// [modelMap] defines a mapping between field label Strings and [ModelType] models. It cannot be null or empty.
  ///
  /// Each time the [ModelInner] is updated, the [modelValidator] function is run on the resulting map
  /// (with the updated values). If the validation fails, a [ValidationException] will be logged
  /// and the current instance will be returned, without having the update applied.
  ///
  /// If [strictUpdates] is true, every update must contain all fields defined in [modelMap]
  /// and every field value cannot be null and must be valid. If it's false, updates can
  /// contain a sub-set of the fields.
  ///
  /// Throws a [ModelInitializationError] if [modelValidator] is false after being run on [modelMap],
  /// during initialization only.
  static ModelInner inner(
    Map<String, ModelType> model, {
    ModelValidator modelValidator,
    bool strictUpdates = false,
    String fieldLabel,
  }) =>
      ModelInner(model, modelValidator, strictUpdates, fieldLabel);

  static ModelEnum<E> enm<E>(
    List<E> enums,
    E initial, {
    String fieldLabel,
  }) =>
      ModelEnum(enums, initial, fieldLabel);

  static ModelBool bl({
    bool initialValue,
    String fieldLabel,
  }) =>
      ModelBool(initialValue, fieldLabel);

  static ModelInt nt({
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt(initialValue, validator, fieldLabel);

  static ModelDouble dbl({
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  }) =>
      ModelDouble(initialValue, validator, fieldLabel);

  static ModelString str({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString(initialValue, validator, fieldLabel);

  static ModelString txt({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString.text(initialValue, validator, fieldLabel);

  static ModelDateTime dt({
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime(initialValue, validator, fieldLabel);

  static ModelList<bool> blList({
    List<bool> initialValue,
    ListItemValidator<bool> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.boolList(initialValue, append, fieldLabel);

  static ModelList<int> ntList({
    List<int> initialValue,
    ListItemValidator<int> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.intList(initialValue, validator, append, fieldLabel);

  static ModelList<double> dblList({
    List<double> initialValue,
    ListItemValidator<double> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.doubleList(initialValue, validator, append, fieldLabel);

  static ModelList<String> strList({
    List<String> initialValue,
    ListItemValidator<String> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.stringList(initialValue, validator, append, fieldLabel);

  static ModelList<DateTime> dtList({
    List<DateTime> initialValue,
    ListItemValidator<DateTime> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.dateTimeList(initialValue, validator, append, fieldLabel);

  /// A list of maps where each map must comply to the structure defined by [model]
  /// and where each element in the map must have a value.
  ///
  /// The validation is performed using using a
  static ModelValidatedList mvList(
    ModelInner model, {
    List<Map<String, dynamic>> initialValue,
    bool append = true,
  }) =>
      ModelValidatedList(model, initialValue, append);

  // value types
  static ModelEmail email({
    String defaultEmail,
  }) =>
      ModelEmail(defaultEmail);

  static ModelPassword password() => ModelPassword();
}
