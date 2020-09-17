import 'package:flutter/material.dart';
import 'package:immutable_model/immutable_model.dart';

import 'redux/user/user_state.dart';
import 'redux/user/user_reducer.dart';

import 'redux/auth/auth_state.dart';
import 'redux/auth/auth_reducer.dart';

import 'redux/weather/weather_state.dart';
import 'redux/weather/weather_reducer.dart';

@immutable
class AppState {
  final ImmutableModel<AuthState> authModel;
  final ImmutableModel<UserState> userModel;
  final ImmutableModel<WeatherState> weatherModel;

  AppState({
    @required this.authModel,
    @required this.userModel,
    @required this.weatherModel,
  });
  AppState.inital()
      : authModel = authStateModel,
        userModel = userStateModel,
        weatherModel = weatherStateModel;
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    authModel: AuthReducer().call(state.authModel, action),
    userModel: UserReducer().call(state.userModel, action),
    weatherModel: WeatherReducer().call(state.weatherModel, action),
  );
}
