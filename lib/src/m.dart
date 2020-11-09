import 'package:meta/meta.dart';

import '../model_types.dart';
import '../value_types.dart';
import './immutable_model.dart';

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
    List<E> enumValues, {
    @required E initial,
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
        initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initial,
    ValueValidator<int> validator,
    String fieldLabel,
  }) =>
      ModelInt(
        initial,
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
        initial,
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
        initial,
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
        initial,
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
        initial,
        validator: validator,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelBoolList]
  static ModelBoolList blList({
    List<bool> initial,
    String fieldLabel,
  }) =>
      ModelBoolList(
        initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelIntList]
  static ModelIntList ntList({
    List<int> initial,
    ListItemValidator<int> itemValidator,
    String fieldLabel,
  }) =>
      ModelIntList(
        initial,
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
        initial,
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
        initial,
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
        initial,
        itemValidator: itemValidator,
        fieldLabel: fieldLabel,
      );

  static ModelEnumList<E> enList<E>(
    List<E> enumValues, {
    List<E> initial,
    String fieldLabel,
  }) =>
      ModelEnumList<E>(
        enumValues,
        initial,
        fieldLabel: fieldLabel,
      );

  static ModelValueList<M> mvList<M extends ModelValue<M, dynamic>>(
    M defaultModel, {
    List initial,
    String fieldLabel,
  }) =>
      ModelValueList(
        defaultModel,
        initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelInnerList]
  static ModelInnerList inList(
    ModelInner model, {
    List<Map<String, dynamic>> initial,
    String fieldLabel,
  }) =>
      ModelInnerList(
        model,
        initial,
        fieldLabel: fieldLabel,
      );

  /// Returns a [ModelInnerList] using an [ImmutableModel]
  static ModelInnerList imList(
    ImmutableModel model, {
    List<Map<String, dynamic>> initial,
    String fieldLabel,
  }) =>
      ModelInnerList.fromIM(
        model,
        initial,
        fieldLabel: fieldLabel,
      );

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
    String fieldLabel,
  }) =>
      ModelEmail(
        defaultEmail,
        fieldLabel: fieldLabel,
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
