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
abstract class M {
  // model types

  /// Returns a [ModelInner]
  static ModelInner inner(
    Map<String, ModelType> modelMap, {
    ModelMapValidator modelValidator,
    bool strictUpdates = false,
    String fieldLabel,
  }) =>
      ModelInner(
        modelMap,
        modelValidator: modelValidator,
        strictUpdates: strictUpdates,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelEnum]
  static ModelEnum<E> enm<E>(
    List<E> enumValues,
    E initial, {
    String fieldLabel,
  }) =>
      ModelEnum(
        enumValues,
        initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelBool]
  static ModelBool bl({
    bool initial,
    String fieldLabel,
  }) =>
      ModelBool(
        initial: initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initial,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt(
        initial: initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelDouble]
  static ModelDouble dbl({
    double initial,
    ValueValidator<double> validator,
    String fieldLabel,
  }) =>
      ModelDouble(
        initial: initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelString]
  static ModelString str({
    String initial,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString(
        initial: initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelString]
  static ModelString txt({
    String initial,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString.text(
        initial: initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelDateTime]
  static ModelDateTime dt({
    DateTime initial,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  }) =>
      ModelDateTime(
        initial: initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelBoolList]
  static ModelBoolList blList({
    List<bool> initial,
    String fieldLabel,
  }) =>
      ModelBoolList(
        initial: initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelIntList]
  static ModelIntList ntList({
    List<int> initial,
    ListItemValidator<int> itemValidator,
    String fieldLabel,
  }) =>
      ModelIntList(
        initial: initial,
        itemValidator: itemValidator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelDoubleList]
  static ModelDoubleList dblList({
    List<double> initial,
    ListItemValidator<double> itemValidator,
    String fieldLabel,
  }) =>
      ModelDoubleList(
        initial: initial,
        itemValidator: itemValidator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelStringList]
  static ModelStringList strList({
    List<String> initial,
    ListItemValidator<String> itemValidator,
    String fieldLabel,
  }) =>
      ModelStringList(
        initial: initial,
        itemValidator: itemValidator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelDateTimeList]
  static ModelDateTimeList dtList({
    List<DateTime> initial,
    ListItemValidator<DateTime> itemValidator,
    String fieldLabel,
  }) =>
      ModelDateTimeList(
        initial: initial,
        itemValidator: itemValidator,
        fieldLabel: fieldLabel,
      );

  // /// Returns a [ModelList.modelValidatedList]
  // static ModelValidatedList mvList(
  //   ModelInner model, {
  //   List<Map<String, dynamic>> initialList,
  //   bool append = true,
  //   String fieldLabel,
  // }) =>
  //     ModelValidatedList(model, initialList: initialList, append: append, fieldLabel: fieldLabel);

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
    String fieldLabel,
  }) =>
      ModelEmail(
        defaultEmail,
      );

  /// Returns a [ModelPassword]
  static ModelPassword password({
    String fieldLabel,
  }) =>
      ModelPassword(
        null,
        fieldLabel: fieldLabel,
      );
}
