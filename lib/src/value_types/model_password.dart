import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../model_type.dart';
import '../model_value.dart';

class ModelPassword extends ModelValue<ModelPassword, String> with ValueType {
  static final ValueValidator<String> validator =
      (pwdStr) => RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$").hasMatch(pwdStr);

  ModelPassword([String password, String fieldLabel = 'password']) : super.text(password, validator, fieldLabel);

  ModelPassword._next(ModelPassword previous, String value) : super.constructNext(previous, value);

  @override
  ModelPassword buildNext(String nextValue) => ModelPassword._next(this, nextValue);

  @override
  String asSerializable() => sha256.convert(utf8.encode(value)).toString();
}
