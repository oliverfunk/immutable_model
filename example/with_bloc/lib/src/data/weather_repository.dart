import 'dart:math';

import 'package:immutable_model/immutable_model.dart';

import '../domain/cubits/weather_cubit.dart';
import '../domain/models/weather_state.dart';

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
        if (random.nextInt(11) > 2) {
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
        return WeatherState.model.fromJson(returnedJson);
      },
    );
  }
}

class NetworkException implements Exception {}
