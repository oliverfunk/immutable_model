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

  /// Returns a [ModelInner]
  static ModelInner inner(
    Map<String, ModelType> model, {
    ModelValidator modelValidator,
    bool strictUpdates = false,
    String fieldLabel,
  }) =>
      ModelInner(model, modelValidator, strictUpdates, fieldLabel);

  /// Returns a [ModelEnum]
  static ModelEnum<E> enm<E>(
    List<E> enums,
    E initial, {
    String fieldLabel,
  }) =>
      ModelEnum(enums, initial, fieldLabel);

  /// Returns a [ModelBool]
  static ModelBool bl({
    bool initialValue,
    String fieldLabel,
  }) =>
      ModelBool(initialValue, fieldLabel);

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt(initialValue, validator, fieldLabel);

  /// Returns a [ModelDouble]
  static ModelDouble dbl({
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  }) =>
      ModelDouble(initialValue, validator, fieldLabel);

  /// Returns a [ModelString]
  static ModelString str({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString(initialValue, validator, fieldLabel);

  /// Returns a [ModelString]
  static ModelString txt({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString.text(initialValue, validator, fieldLabel);

  /// Returns a [ModelDateTime]
  static ModelDateTime dt({
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime(initialValue, validator, fieldLabel);

  /// Returns a [ModelList.boolList]
  static ModelList<bool> blList({
    List<bool> initialValue,
    ListItemValidator<bool> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.boolList(initialValue, append, fieldLabel);

  /// Returns a [ModelList.intList]
  static ModelList<int> ntList({
    List<int> initialValue,
    ListItemValidator<int> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.intList(initialValue, validator, append, fieldLabel);

  /// Returns a [ModelList.doubleList]
  static ModelList<double> dblList({
    List<double> initialValue,
    ListItemValidator<double> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.doubleList(initialValue, validator, append, fieldLabel);

  /// Returns a [ModelList.stringList]
  static ModelList<String> strList({
    List<String> initialValue,
    ListItemValidator<String> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.stringList(initialValue, validator, append, fieldLabel);

  /// Returns a [ModelList.dateTimeList]
  static ModelList<DateTime> dtList({
    List<DateTime> initialValue,
    ListItemValidator<DateTime> validator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.dateTimeList(initialValue, validator, append, fieldLabel);

  /// Returns a [ModelList.modelValidatedList]
  static ModelList<Map<String, dynamic>> mvList(
    ModelInner model, {
    List<Map<String, dynamic>> initialValue,
    bool append = true,
  }) =>
      ModelList.modelValidatedList(model, initialValue, append);

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
  }) =>
      ModelEmail(defaultEmail);

  /// Returns a [ModelPassword]
  static ModelPassword password() => ModelPassword();
}
