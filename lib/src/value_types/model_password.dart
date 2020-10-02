import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../model_value.dart';

/// A model of a valid password string.
class ModelPassword extends ModelValue<ModelPassword, String> with ValueType {
  static bool validator(String pwdStr) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$").hasMatch(pwdStr);

  /// Constructs a [ModelValue] of a [String] for a password [ValueType].
  ///
  /// The password string must contain at least one upper case letter, one lower case letter and a number.
  ///
  /// The password string is hashed when [asSerializable] is called. This is to mitigate against the cleartext password
  /// being sent down the wire.
  ModelPassword(
    String password, {
    String fieldLabel = 'password',
  }) : super.text(password, validator, fieldLabel);

  ModelPassword._next(ModelPassword previous, String value) : super.constructNext(previous, value);

  @override
  ModelPassword buildNext(String nextValue) => ModelPassword._next(this, nextValue);

  @override
  String asSerializable() => sha256.convert(utf8.encode(value)).toString();
}
