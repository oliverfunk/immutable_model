import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';

import 'weather_state.dart';

@immutable
abstract class WeatherAction {
  const WeatherAction();
}

class FetchWeatherBegin extends WeatherAction {
  final CityName cityName;

  const FetchWeatherBegin(this.cityName);
}

class FetchWeatherSuccess extends WeatherAction {
  final ImmutableModel<WeatherState> returnedModel;
  const FetchWeatherSuccess(this.returnedModel);
}

class FetchWeatherFailure extends WeatherAction {
  const FetchWeatherFailure();
}
