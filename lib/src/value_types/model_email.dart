import 'package:immutable_model/immutable_model.dart';
import 'package:meta/meta.dart';

/// A model of a valid email address string
class ModelEmail extends ModelValueType<ModelEmail, String> with ValueType {
  /// The validator function for the email value type.
  ///
  /// todo: better describe the validation
  /// This will check [emailStr] is structured properly.
  static bool validator(String emailStr) =>
      emailStr.isEmpty ||
      RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$")
          .hasMatch(emailStr);

  /// Constructs a [ModelValue] of a [String] for an email address [ValueType].
  ModelEmail(
    String? emailString, {
    String label = 'email',
  }) : super.initial(
          emailString,
          validator: validator,
          label: label,
        );

  ModelEmail._next(ModelEmail previous, String value)
      : super.constructNext(previous, value);

  @override
  @protected
  ModelEmail buildNext(String nextValue) => ModelEmail._next(this, nextValue);
}
