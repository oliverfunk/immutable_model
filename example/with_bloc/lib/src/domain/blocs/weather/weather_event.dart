part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final CityName cityName;

  const FetchWeather(this.cityName);
}
