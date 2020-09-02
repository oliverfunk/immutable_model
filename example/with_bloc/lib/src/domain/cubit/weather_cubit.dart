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

  WeatherCubit(this._weatherRepository) : super(WeatherState.model);

  String get cityName => state[CityName.label];
  double get temperature => state["weather_data"]["temperature"];
  String get weather => state["weather_data"]["weather"];

  Future<void> getWeather(CityName cityName) async {
    try {
      emit(state.transitionToWithUpdate(
        WeatherLoading(),
        {
          cityName.fieldLabel: cityName,
        },
      ));
      final weatherModel = await _weatherRepository.fetchWeather(cityName.value);
      emit(state.transitionTo(WeatherLoaded()).mergeFrom(weatherModel));
    } on NetworkException {
      emit(state.transitionTo(WeatherError("Couldn't fetch weather. Is the device online?")));
    }
  }
}
