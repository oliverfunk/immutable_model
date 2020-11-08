import 'dart:math';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:immutable_model/value_types.dart';

import '../../app_state.dart';
import '../user/user_action.dart';
import 'auth_action.dart';

// fake auth'ing function
Future<bool> _authUser(String email, String password) => Future.delayed(
      Duration(seconds: 1),
      // 1 in 5 chance of being false
      () => Random().nextInt(10) > 1,
    );

ThunkAction<AppState> signIn(ModelEmail email, ModelPassword password) {
  return (Store<AppState> store) async {
    store.dispatch(SignInBegin(email, password));
    // do some authorization using auth repo functions
    final didAuth = await _authUser(
      email.asSerializable(),
      password.asSerializable(),
    );
    if (didAuth) {
      store.dispatch(AuthUser(email));
      store.dispatch(SignInSuccess());
    } else {
      store.dispatch(UnauthUser());
      store.dispatch(SignInFailure());
    }
  };
}
