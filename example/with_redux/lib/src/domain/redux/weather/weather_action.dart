import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import 'weather_model.dart';

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

class SetPreviousWeather extends WeatherAction {
  final ModelInner previous;
  const SetPreviousWeather(this.previous);
}
