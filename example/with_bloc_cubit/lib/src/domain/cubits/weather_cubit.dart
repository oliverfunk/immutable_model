import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../../data/weather_repository.dart';
import '../models/weather_state.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

class WeatherCubit extends Cubit<ImmutableModel<WeatherState>> {
  final WeatherRepository _weatherRepository;

  WeatherCubit(this._weatherRepository) : super(weatherStateModel);

  Future<void> fetchWeather(CityName cityName) async {
    try {
      emit(state.transitionToAndUpdate(
        const WeatherLoading(),
        {
          cityName.fieldLabel: cityName,
        },
      ));
      final weatherModel = await _weatherRepository.fetchWeather(cityName.asSerializable());
      // the mergeFrom method ignores default values from the weatherModel passed back by the repo
      emit(state.transitionTo(const WeatherLoaded()).mergeFrom(weatherModel));
    } on NetworkException {
      emit(state.transitionTo(const WeatherError("Couldn't fetch weather. Is the device online?")));
    }
  }
}
