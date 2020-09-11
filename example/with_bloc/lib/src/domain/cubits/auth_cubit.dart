import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import 'user_cubit.dart';
import '../models/auth_state.dart';

// fake auth'ing function
Future<bool> _authUser(String email, String password) => Future.delayed(
      Duration(seconds: 1),
      () {
        // 1 in 5 chance
        return Random().nextInt(11) > 2;
        // return true;
      },
    );

class AuthCubit extends Cubit<ImmutableModel<AuthState>> {
  final UserCubit userCubit;

  AuthCubit(this.userCubit) : super(AuthState.model);

  Future<void> signIn(ModelEmail email, ModelPassword password) async {
    emit(state.transitionToAndUpdate(const AuthLoading(), {
      'email': email,
      'password': password,
    }));
    // do some authroization using auth repo functions
    final didAuth = await _authUser(email.asSerializable(), password.asSerializable());
    if (didAuth) {
      userCubit.userAuthed(email);
      emit(state.transitionTo(const AuthSuccess()));
    } else {
      userCubit.userUnauthed();
      emit(state.transitionTo(const AuthError()));
    }
  }
}
