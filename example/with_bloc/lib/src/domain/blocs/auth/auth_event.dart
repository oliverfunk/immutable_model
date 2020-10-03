import 'package:flutter/foundation.dart';
import 'package:immutable_model/value_types.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class SignIn extends AuthEvent {
  final ModelEmail email;
  final ModelPassword password;

  const SignIn(this.email, this.password);
}
