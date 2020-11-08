import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../../../data/weather_repository.dart';
import 'weather_state.dart';
import 'weather_event.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

class WeatherBloc extends Bloc<WeatherEvent, ImmutableModel<WeatherState>> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(weatherStateModel);

  @override
  Stream<ImmutableModel<WeatherState>> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is FetchWeather) {
      try {
        yield state.transitionToAndUpdate(
          const WeatherLoading(),
          {
            CityName.label: event.cityName,
          },
        );
        final weatherModel = await _weatherRepository
            .fetchWeather(event.cityName.asSerializable());
        // the mergeFrom method ignores default values from the weatherModel passed back by the repo
        yield state.transitionTo(const WeatherLoaded()).mergeFrom(weatherModel);
      } on NetworkException {
        yield state.transitionTo(
          const WeatherError("Couldn't fetch weather. Is the device online?"),
        );
      }
    }
  }
}
