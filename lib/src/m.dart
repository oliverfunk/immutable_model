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
      );

  /// Returns a [ModelEnum]
  static ModelEnum<E> enm<E>({
    @required List<E> enumValues,
    @required E initial,
    String fieldLabel,
  }) =>
      ModelEnum(enumValues, initial);

  /// Returns a [ModelBool]
  static ModelBool bl({
    bool initial,
    String fieldLabel,
  }) =>
      ModelBool(initial);

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initial,
    ValueValidator<int> validator,
  }) =>
      ModelInt(initial, validator);

  /// Returns a [ModelDouble]
  static ModelDouble dbl({
    double initial,
    ValueValidator<double> validator,
  }) =>
      ModelDouble(initial, validator);

  /// Returns a [ModelString]
  static ModelString str({
    String initial,
    ValueValidator<String> validator,
    String fieldLabel,
  }) =>
      ModelString(initial, validator);

  /// Returns a [ModelString]
  static ModelString txt({
    String initial,
    ValueValidator<String> validator,
  }) =>
      ModelString.text(initial, validator);

  /// Returns a [ModelDateTime]
  static ModelDateTime dt({
    DateTime initial,
    ValueValidator<DateTime> validator,
  }) =>
      ModelDateTime(initial, validator);

  /// Returns a [ModelBoolList]
  static ModelBoolList blList({
    List<bool> initial,
  }) =>
      ModelBoolList(initial);

  /// Returns a [ModelIntList]
  static ModelIntList ntList({
    List<int> initial,
    ListItemValidator<int> itemValidator,
  }) =>
      ModelIntList(initial, itemValidator);

  /// Returns a [ModelDoubleList]
  static ModelDoubleList dblList({
    List<double> initial,
    ListItemValidator<double> itemValidator,
  }) =>
      ModelDoubleList(initial, itemValidator);

  /// Returns a [ModelStringList]
  static ModelStringList strList({
    List<String> initial,
    ListItemValidator<String> itemValidator,
  }) =>
      ModelStringList(initial, itemValidator);

  /// Returns a [ModelDateTimeList]
  static ModelDateTimeList dtList({
    List<DateTime> initial,
    ListItemValidator<DateTime> itemValidator,
  }) =>
      ModelDateTimeList(initial, itemValidator);

  static ModelEnumList<E> enmList<E>({
    @required List<E> enumValues,
    List<E> initial,
  }) =>
      ModelEnumList<E>(enumValues, initial);

  /// Returns a [ModelValueList]
  static ModelValueList<M> mvList<M extends ModelValue<M, dynamic>>({
    @required M defaultModel,
    List initial,
  }) =>
      ModelValueList(defaultModel, initial);

  /// Returns a [ModelInnerList]
  static ModelInnerList inList({
    @required ModelInner innerModel,
    List<Map<String, dynamic>> initial,
  }) =>
      ModelInnerList(innerModel, initial);

  /// Returns a [ModelInnerList] using an [ImmutableModel]
  static ModelInnerList imList({
    @required ImmutableModel model,
    List<Map<String, dynamic>> initial,
  }) =>
      ModelInnerList.fromIM(model, initial);

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
  }) =>
      ModelEmail(defaultEmail);

  /// Returns a [ModelPassword]
  static ModelPassword password() => ModelPassword(null);
}
