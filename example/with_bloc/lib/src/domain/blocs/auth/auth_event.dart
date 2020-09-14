part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class SignIn extends AuthEvent {
  final ModelEmail email;
  final ModelPassword password;

  const SignIn(this.email, this.password);
}
