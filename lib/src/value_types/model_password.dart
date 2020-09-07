import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../model_types.dart';
import '../model_types/model_primitive.dart';

class ModelPassword extends ModelPrimitive<String> {
  static final ValueValidator<String> validator =
      (pwdStr) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$", caseSensitive: false).hasMatch(pwdStr);

  ModelPassword([String value, String fieldLabel = 'password']) : super.string(value, validator, fieldLabel);

  ModelPassword._constructNext(ModelPassword last, value) : super.constructNext(last, value);

  @override
  ModelPassword build(String value) => ModelPassword._constructNext(this, value);

  @override
  String asSerializable() => sha256.convert(utf8.encode(value)).toString();

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelPassword;
}
