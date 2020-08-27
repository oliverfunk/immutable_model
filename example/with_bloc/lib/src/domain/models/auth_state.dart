import 'package:immutable_model/immutable_model.dart';

abstract class AuthState {
  static final model = ImmutableModel<AuthState>(
    {
      "email": M.email(),
      "password": M.password(),
    },
    initalState: AuthInitial(),
  );

  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class AuthError extends AuthState {
  const AuthError();
}
