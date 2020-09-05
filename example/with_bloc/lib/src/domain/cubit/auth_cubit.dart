import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import 'user_cubit.dart';
import '../models/auth_state.dart';

class AuthCubit extends Cubit<ImmutableModel<AuthState>> {
  final UserCubit userCubit;

  AuthCubit(this.userCubit) : super(AuthState.model);

  void signIn(ModelEmail email, ModelPassword password) {
    emit(state.transitionToAndUpdate(const AuthLoading(), {
      'email': email,
      'password': password,
    }));
    // do some authroization
    // if the user auth's
    userCubit.userAuthed(email, password);
    emit(state.transitionTo(const AuthSuccess()));
  }
}
