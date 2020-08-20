import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../model_value.dart';
import '../model_types/model_primitive.dart';

class ModelPassword extends ModelPrimitive<String> {
  static final validator =
      (pwdStr) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$", caseSensitive: false).hasMatch(pwdStr);

  ModelPassword([String defaultPassword, String fieldLabel = 'password'])
      : super.string(defaultPassword, validator, fieldLabel);

  @override
  String asSerializable() => sha256.convert(utf8.encode(value)).toString();

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelPassword;
}
