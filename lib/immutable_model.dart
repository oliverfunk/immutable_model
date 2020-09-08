library immutable_model;

import 'model_types.dart';
import 'value_types.dart';

// make your domain layer proovably safe with immutable_model
// no exception should need to be delt with in the domain layer only in the UI or Data
// help you write sound, authorative domain layer
// helps you find out why ur app is broken for ex. if the data source changes format IM excp should be thrown when desearliseing
// the way you write the domain layer ebcomes the contract for the entire app. It forces the correct implementation.

// todo: gen GraphQL query
// todo: try use lists for models
// todo: diff method for sending data
// TODO: big problems. Think of a way to make it easy to access model values when defiing a model
// possibly using static Strings but then what if you want to set ur own fieldLabel for ex. in email
// maybe you want user_email

// expose only erros, the main immutable_model class and the M. shorthands
export 'src/errors.dart';
export 'src/immutable_model.dart';

abstract class M {
  // model types
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
