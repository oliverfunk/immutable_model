library immutable_model;

// expose only the exceptions, the main immutable_model class and the M. shorthands
export 'src/exceptions.dart';
export 'src/immutable_model.dart';

import 'src/immutable_model.dart';
import 'model_types.dart';
import 'value_types.dart';

class M {
  // model types
  static ModelInner inner(Map<String, ModelValue> model) => ModelInner(model);

  static ModelEnum<E> enm<E>(List<E> enums, E initial, [String fieldName]) =>
      ModelEnum.fromEnumList(enums, initial, fieldName);

  static ModelPrimitive<bool> bl(bool initial, [String fieldName]) => ModelPrimitive.bool(initial, fieldName);

  static ModelPrimitive<int> nt([int initial, ValueValidator<int> validator, String fieldName]) =>
      ModelPrimitive.int(initial, validator, fieldName);

  static ModelPrimitive<double> dbl([double initial, ValueValidator<double> validator, String fieldName]) =>
      ModelPrimitive.double(initial, validator, fieldName);

  static ModelPrimitive<String> str([String initial, ValueValidator<String> validator, String fieldName]) =>
      ModelPrimitive.string(initial, validator, fieldName);

  static ModelPrimitive<DateTime> dt([DateTime initial, ValueValidator<DateTime> checker, String fieldName]) =>
      ModelPrimitive.datetime(initial, checker, fieldName);

  static ModelList<bool> blList(
          [List<bool> initialList, ListItemValidator<bool> listItemValidator, bool append = true, String fieldName]) =>
      ModelList.boolList(initialList, append, fieldName);

  static ModelList<int> ntList(
          [List<int> initialList, ListItemValidator<int> listItemValidator, bool append = true, String fieldName]) =>
      ModelList.intList(initialList, listItemValidator, append, fieldName);

  static ModelList<double> dblList(
          [List<double> initialList,
          ListItemValidator<double> listItemValidator,
          bool append = true,
          String fieldName]) =>
      ModelList.doubleList(initialList, listItemValidator, append, fieldName);

  static ModelList<String> strList(
          [List<String> initialList,
          ListItemValidator<String> listItemValidator,
          bool append = true,
          String fieldName]) =>
      ModelList.stringList(initialList, listItemValidator, append, fieldName);

  static ModelList<DateTime> dtList(
          [List<DateTime> initialList,
          ListItemValidator<DateTime> listItemValidator,
          bool append = true,
          String fieldName]) =>
      ModelList.dateTimeList(initialList, listItemValidator, append, fieldName);

  static ModelValidatedList mvList(ImmutableModel model,
          [List<Map<String, dynamic>> initialList, bool append = true]) =>
      ModelValidatedList(model, initialList, append);

  // value types
  static ModelEmail email([String defaultEmail]) => ModelEmail(defaultEmail);
}
