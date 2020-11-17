import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

final authModel = ImmutableModel<AuthState>(
  {
    ModelEmail.label: M.email(defaultEmail: 'example@gmail.com'),
    ModelPassword.label: M.password(),
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
