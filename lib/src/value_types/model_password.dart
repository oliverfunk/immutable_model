import 'package:valid/valid.dart';

import '../model_types/primitives/model_value_type.dart';

/// A model of a valid password string.
class ModelPassword extends ModelValueType<ModelPassword, String>
    with ValueType {
  /// The validator function for the password value type.
  ///
  /// This will check if [pwStr] is at least 8 characters long,
  /// has one upper case and one lower case letter and one number
  static bool validator(String pwStr) =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(pwStr);

  /// Constructs a [ModelValue] of a [String] for a password [ValueType].
  ///
  /// The password string must contain at least one upper case letter, one lower case letter and a number.
  ///
  /// The password string is hashed when [asSerializable] is called. This is to mitigate against the cleartext password
  /// being sent down the wire.
  ModelPassword(
    String fieldLabel,
    String password,
  ) : super.initial(fieldLabel, password, validator);

  ModelPassword._next(ModelPassword previous, String value)
      : super.constructNext(previous, value);

  @override
  ModelPassword buildNext(String nextValue) =>
      ModelPassword._next(this, nextValue);

  // shouldn't be deserializing passwords
  @override
  String? deserializer(dynamic serialized) => null;
}
