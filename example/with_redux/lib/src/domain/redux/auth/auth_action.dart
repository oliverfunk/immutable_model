import 'package:flutter/foundation.dart';
import 'package:immutable_model/value_types.dart';

@immutable
abstract class AuthAction {
  const AuthAction();
}

class SignInBegin extends AuthAction {
  final ModelEmail email;
  final ModelPassword password;

  const SignInBegin(this.email, this.password);
}

class SignInSuccsss extends AuthAction {
  const SignInSuccsss();
}

class SignInFailure extends AuthAction {
  const SignInFailure();
}
