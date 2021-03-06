import 'package:immutable_model/immutable_model.dart';

class AuthModel extends ImmutableModel<AuthModel> {
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
        modelUpdate.forField(email),
        modelUpdate.forField(password),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [
        email,
        password,
      ];
}

abstract class AuthState extends ModelState<AuthState> {
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
