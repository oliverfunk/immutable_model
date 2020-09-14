import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import '../user/user_bloc.dart';
import 'auth_state.dart';
part 'auth_event.dart';

// fake auth'ing function
Future<bool> _authUser(String email, String password) => Future.delayed(
      Duration(seconds: 1),
      () {
        // 1 in 10 chance
        return Random().nextInt(11) > 1;
        // return true;
      },
    );

class AuthBloc extends Bloc<AuthEvent, ImmutableModel<AuthState>> {
  final UserBloc userBloc;
  AuthBloc(this.userBloc) : super(authStateModel);

  @override
  Stream<ImmutableModel<AuthState>> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignIn) {
      yield state.transitionToAndUpdate(const AuthLoading(), {
        'email': event.email,
        'password': event.password,
      });
      // do some authroization using auth repo functions
      final didAuth = await _authUser(event.email.asSerializable(), event.password.asSerializable());
      if (didAuth) {
        userBloc.add(AuthUser(event.email));
        yield state.transitionTo(const AuthSuccess());
      } else {
        userBloc.add(UnauthUser());
        yield state.transitionTo(const AuthError());
      }
    }
  }
}
