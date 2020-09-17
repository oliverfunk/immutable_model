import 'package:redux/redux.dart';
import 'package:immutable_model/immutable_model.dart';

import 'auth_state.dart';
import 'auth_action.dart';

class AuthReducer extends ReducerClass<ImmutableModel<AuthState>> {
  ImmutableModel<AuthState> call(model, action) {
    if (action is SignInBegin) {
      return model.transitionToAndUpdate(const AuthLoading(), {
        'email': action.email,
        'password': action.password,
      });
    } else if (action is SignInSuccsss) {
      return model.transitionTo(const AuthSuccess());
    } else if (action is SignInFailure) {
      return model.transitionTo(const AuthError());
    }

    return model;
  }
}
