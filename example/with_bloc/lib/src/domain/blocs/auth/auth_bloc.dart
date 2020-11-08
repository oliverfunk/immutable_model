import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../user/user_bloc.dart';
import '../user/user_event.dart';
import 'auth_state.dart';
import 'auth_event.dart';

// fake auth'ing function
Future<bool> _authUser(String email, String password) => Future.delayed(
      Duration(seconds: 1),
      // 1 in 5 chance of being false
      () => Random().nextInt(10) > 1,
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
      // do some authorization using auth repo functions
      final didAuth = await _authUser(
        event.email.asSerializable(),
        event.password.asSerializable(),
      );
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
