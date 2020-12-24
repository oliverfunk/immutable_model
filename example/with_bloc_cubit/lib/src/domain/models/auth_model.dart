import 'package:immutable_model/immutable_model.dart';

class AuthModel extends ImmutableModel<AuthModel, AuthState> {
  final ModelEmail email;
  final ModelPassword password;

  AuthModel()
      : email = ModelEmail('default@gmail.com'),
        password = ModelPassword(null),
        super.initial(initialState: const AuthInitial());

  AuthModel._next(
    this.email,
    this.password,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  AuthModel build(ModelUpdate modelUpdate) => AuthModel._next(
        modelUpdate.nextField(email),
        modelUpdate.nextField(password),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [
        email,
        password,
      ];
}

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
