import 'package:meta/meta.dart';

import '../model_types.dart';
import './immutable_model.dart';
import 'typedefs.dart';

/// An abstract holding class defining shorthands for the constructors of each model defined in this library.
///
/// These contractions are useful for keeping definitions of [ImmutableModel]'s concise.
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
  }) =>
      ModelEnum(enumValues, initial);

  /// Returns a [ModelBool]
  static ModelBool bl({
    bool initial,
  }) =>
      ModelBool(initial);

  /// Returns a [ModelInt]
  static ModelInt nt({
    int initial,
    ModelValueValidator<int> validator,
  }) =>
      ModelInt(initial, validator);

  /// Returns a [ModelDouble]
  static ModelDouble dbl({
    double initial,
    ModelValueValidator<double> validator,
  }) =>
      ModelDouble(initial, validator);

  /// Returns a [ModelString]
  static ModelString str({
    String initial,
    ModelValueValidator<String> validator,
  }) =>
      ModelString(initial, validator);

  /// Returns a [ModelString]
  static ModelString txt({
    String initial,
    ModelValueValidator<String> validator,
  }) =>
      ModelString.text(initial, validator);

  /// Returns a [ModelDateTime]
  static ModelDateTime dt({
    DateTime initial,
    ModelValueValidator<DateTime> validator,
  }) =>
      ModelDateTime(initial, validator);

  /// Returns a [ModelBoolList]
  static ModelBoolList blList({
    List<bool> initial = const <bool>[],
  }) =>
      ModelBoolList(initial);

  /// Returns a [ModelIntList]
  static ModelIntList ntList({
    List<int> initial = const <int>[],
    ModelListItemValidator<int> itemValidator,
  }) =>
      ModelIntList(initial, itemValidator);

  /// Returns a [ModelDoubleList]
  static ModelDoubleList dblList({
    List<double> initial = const <double>[],
    ModelListItemValidator<double> itemValidator,
  }) =>
      ModelDoubleList(initial, itemValidator);

  /// Returns a [ModelStringList]
  static ModelStringList strList({
    List<String> initial = const <String>[],
    ModelListItemValidator<String> itemValidator,
  }) =>
      ModelStringList(initial, itemValidator);

  /// Returns a [ModelDateTimeList]
  static ModelDateTimeList dtList({
    List<DateTime> initial = const <DateTime>[],
    ModelListItemValidator<DateTime> itemValidator,
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
    List initialValues = const [],
  }) =>
      ModelValueList(defaultModel, initialValues);

  /// Returns a [ModelInnerList]
  static ModelInnerList inList({
    @required ModelInner innerModel,
    List<Map<String, dynamic>> initialValues = const <Map<String, dynamic>>[],
  }) =>
      ModelInnerList(innerModel, initialValues);

  /// Returns a [ModelInnerList] using an [ImmutableModel]
  static ModelInnerList imList({
    @required ImmutableModel model,
    List<Map<String, dynamic>> initialValues = const <Map<String, dynamic>>[],
  }) =>
      ModelInnerList.fromIM(model, initialValues);

  // value types

  /// Returns a [ModelEmail]
  static ModelEmail email({
    String defaultEmail,
  }) =>
      ModelEmail(defaultEmail);

  /// Returns a [ModelPassword]
  static ModelPassword password() => ModelPassword(null);
}
