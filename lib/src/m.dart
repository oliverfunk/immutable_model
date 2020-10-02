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
      ModelInner(model, modelValidator: modelValidator, strictUpdates: strictUpdates, fieldLabel: fieldLabel);

  /// Returns a [ModelEnum]
  static ModelEnum<E> enm<E>(
    List<E> enums,
    E initial, {
    String fieldLabel,
  }) =>
      ModelEnum(enums, initial, fieldLabel: fieldLabel);

  /// Returns a [ModelBool]
  static ModelBool bl({
    bool initialValue,
    String fieldLabel,
  }) =>
      ModelBool(initialValue: initialValue, fieldLabel: fieldLabel);

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt(initialValue: initialValue, validator: validator, fieldLabel: fieldLabel);

  /// Returns a [ModelDouble]
  static ModelDouble dbl({
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  }) =>
      ModelDouble(initialValue: initialValue, validator: validator, fieldLabel: fieldLabel);

  /// Returns a [ModelString]
  static ModelString str({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString(initialValue: initialValue, validator: validator, fieldLabel: fieldLabel);

  /// Returns a [ModelString]
  static ModelString txt({
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString.text(initialValue: initialValue, validator: validator, fieldLabel: fieldLabel);

  /// Returns a [ModelDateTime]
  static ModelDateTime dt({
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime(initialValue: initialValue, validator: validator, fieldLabel: fieldLabel);

  /// Returns a [ModelList.boolList]
  static ModelList<bool> blList({
    List<bool> initialList,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.boolList(initialList: initialList, append: append, fieldLabel: fieldLabel);

  /// Returns a [ModelList.intList]
  static ModelList<int> ntList({
    List<int> initialList,
    ListItemValidator<int> itemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.intList(
          initialList: initialList, listItemValidator: itemValidator, append: append, fieldLabel: fieldLabel);

  /// Returns a [ModelList.doubleList]
  static ModelList<double> dblList({
    List<double> initialList,
    ListItemValidator<double> itemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.doubleList(
          initialList: initialList, listItemValidator: itemValidator, append: append, fieldLabel: fieldLabel);

  /// Returns a [ModelList.stringList]
  static ModelList<String> strList({
    List<String> initialList,
    ListItemValidator<String> itemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.stringList(
          initialList: initialList, listItemValidator: itemValidator, append: append, fieldLabel: fieldLabel);

  /// Returns a [ModelList.dateTimeList]
  static ModelList<DateTime> dtList({
    List<DateTime> initialList,
    ListItemValidator<DateTime> itemValidator,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.dateTimeList(
          initialList: initialList, listItemValidator: itemValidator, append: append, fieldLabel: fieldLabel);

  /// Returns a [ModelList.modelValidatedList]
  static ModelList<Map<String, dynamic>> mvList(
    ModelInner model, {
    List<Map<String, dynamic>> initialList,
    bool append = true,
    String fieldLabel,
  }) =>
      ModelList.modelValidatedList(model, initialList: initialList, append: append, fieldLabel: fieldLabel);

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
    String fieldLabel,
  }) =>
      ModelEmail(defaultEmail);

  /// Returns a [ModelPassword]
  static ModelPassword password({
    String fieldLabel,
  }) =>
      ModelPassword(null, fieldLabel: fieldLabel);
}
