import 'package:flutter/foundation.dart';

import 'weather_model.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final CityName cityName;

  const FetchWeather(this.cityName);
}

class SetToPrevious extends WeatherEvent {
  const SetToPrevious();
}
