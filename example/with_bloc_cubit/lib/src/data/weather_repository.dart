import 'dart:math';

import '../domain/cubits/weather_cubit.dart';
import '../domain/models/weather_model.dart';

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherDataModel> fetchWeatherData(String cityName) {
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
          "temperature": 10 + random.nextInt(5) + random.nextDouble(),
          "weather": ["Sunny", "Rainy", "Cloudy", "Windy"][random.nextInt(4)],
        };

        // Return "fetched" weather
        final wdm = WeatherDataModel().fromJson(returnedJson);
        return wdm;
      },
    );
  }
}

class NetworkException implements Exception {}
