import 'package:flutter/foundation.dart';

import 'weather_state.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final CityName cityName;

  const FetchWeather(this.cityName);
}
