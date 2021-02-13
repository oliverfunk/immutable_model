import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import 'user_cubit.dart';
import '../models/auth_model.dart';

// fake auth'ing function
Future<bool> _authUser(String email, String password) => Future.delayed(
      Duration(seconds: 1),
      // 1 in 5 chance of being false
      () => Random().nextInt(10) > 1,
    );

class AuthCubit extends Cubit<AuthModel> {
  final UserCubit userCubit;

  AuthCubit(this.userCubit) : super(AuthModel());

  Future<void> signIn(ModelEmail email, ModelPassword password) async {
    emit(state.updateFieldsAndTransitionTo(
      const AuthLoading(),
      fieldUpdates: [
        FieldUpdate(
          field: state.email,
          update: email,
        ),
        FieldUpdate(
          field: state.password,
          update: password,
        ),
      ],
    ));
    // do some authorization using auth repo functions
    final didAuth = await _authUser(
      email.asSerializable(),
      password.asSerializable(),
    );
    if (didAuth) {
      userCubit.authUser(email);
      emit(state.transitionTo(const AuthSuccess()));
    } else {
      userCubit.unauthUser();
      emit(state.transitionTo(const AuthError()));
    }
  }
}
