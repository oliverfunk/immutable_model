import 'package:flutter/foundation.dart';
import 'package:immutable_model/model_types.dart';

@immutable
abstract class AuthAction {
  const AuthAction();
}

class SignInBegin extends AuthAction {
  final ModelEmail email;
  final ModelPassword password;

  const SignInBegin(this.email, this.password);
}

class SignInSuccess extends AuthAction {
  const SignInSuccess();
}

class SignInFailure extends AuthAction {
  const SignInFailure();
}
