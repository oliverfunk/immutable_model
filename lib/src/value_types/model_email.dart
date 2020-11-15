import '../model_value.dart';

/// A model of a valid email address string
class ModelEmail extends ModelValue<ModelEmail, String> with ValueType {
  /// The validator function for the email value type.
  ///
  /// todo: better describe the validation
  /// This will check [emailStr] is structured properly.
  static bool validator(String emailStr) => RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$")
      .hasMatch(emailStr);

  /// Default field label, use is optional
  static String label = "email";

  /// Constructs a [ModelValue] of a [String] for an email address [ValueType].
  ModelEmail(
    String email,
  ) : super.text(email, validator);

  ModelEmail._next(ModelEmail previous, String value)
      : super.constructNext(previous, value);

  @override
  ModelEmail buildNext(String nextValue) => ModelEmail._next(this, nextValue);
}
