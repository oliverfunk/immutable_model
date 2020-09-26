import 'package:immutable_model/immutable_model.dart';

final authStateModel = ImmutableModel<AuthState>(
  {
    "email": M.email(defaultEmail: 'example@gmail.com'),
    "password": M.password(),
  },
  initialState: const AuthInitial(),
);

abstract class AuthState {
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
