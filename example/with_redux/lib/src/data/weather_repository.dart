import 'dart:math';

import 'package:immutable_model/immutable_model.dart';

import '../domain/redux/weather/weather_thunks.dart';
import '../domain/redux/weather/weather_model.dart';

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        // Simulate some network exception
        final random = Random();
        // 1 in 5 chance
        if (random.nextInt(10) <= 1) {
          throw NetworkException();
        }

        // faux returned json
        final returnedJson = {
          "weather_data": {
            "temperature": 10 + random.nextInt(5) + random.nextDouble(),
            "weather": ["Sunny", "Rainy", "Cloudy", "Windy"][random.nextInt(4)],
          }
        };

        // Return "fetched" weather
        return weatherModel.fromJson(returnedJson);
      },
    );
  }
}

class NetworkException implements Exception {}
