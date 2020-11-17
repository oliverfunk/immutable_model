import 'package:flutter/material.dart';
import 'package:immutable_model/immutable_model.dart';

import 'redux/user/user_model.dart';
import 'redux/user/user_reducer.dart';

import 'redux/auth/auth_model.dart';
import 'redux/auth/auth_reducer.dart';

import 'redux/weather/weather_model.dart';
import 'redux/weather/weather_reducer.dart';

@immutable
class AppState {
  final ImmutableModel<AuthState> auth;
  final ImmutableModel<UserState> user;
  final ImmutableModel<WeatherState> weather;

  AppState({
    @required this.auth,
    @required this.user,
    @required this.weather,
  });
  AppState.initial()
      : auth = authModel,
        user = userModel,
        weather = weatherModel;
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    auth: AuthReducer().call(state.auth, action),
    user: UserReducer().call(state.user, action),
    weather: WeatherReducer().call(state.weather, action),
  );
}
