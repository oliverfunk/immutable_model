import 'dart:math';

import 'package:immutable_model/immutable_model.dart';

import '../domain/cubit/weather_cubit.dart';
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
        // if (random.nextBool()) {
        //   throw NetworkException();
        // }

        // faux returned json
        final returnedJson = {
          "weather_data": {
            "temperature": 20 + random.nextInt(15) + random.nextDouble(),
            "weather": "Sunny",
          }
        };

        // Return "fetched" weather
        return WeatherState.model.fromJson(returnedJson);
      },
    );
  }
}

class NetworkException implements Exception {}
