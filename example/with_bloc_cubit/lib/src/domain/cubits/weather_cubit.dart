import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../../data/weather_repository.dart';
import '../models/weather_model.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

class WeatherCubit extends Cubit<ImmutableModel<WeatherState>> {
  final WeatherRepository _weatherRepository;
  // can safely expose this because it's immutable
  ModelInnerList previousList;

  WeatherCubit(this._weatherRepository)
      : previousList = ModelInnerList.fromIM(weatherModel),
        super(weatherModel);

  void _appendToPrevious() => previousList = previousList.append([state.inner]);
  // will fail if numberOfItems is 0
  void _removeLastFromPrevious() =>
      previousList = previousList.removeAt(previousList.numberOfItems - 1);

  void setToPrevious() {
    if (previousList.numberOfItems >= 1) {
      emit(
        state
            .transitionTo(const WeatherLoaded())
            .updateWithInner(previousList.last),
      );
      _removeLastFromPrevious();
    }
  }

  Future<void> fetchWeather(CityName cityName) async {
    // append if weather is loaded and fetchWeather is being called again
    if (state.currentState is WeatherLoaded) {
      _appendToPrevious();
    }

    emit(state.transitionToAndUpdate(
      const WeatherLoading(),
      {
        CityName.label: cityName,
      },
    ));

    try {
      final weatherModel =
          await _weatherRepository.fetchWeather(cityName.asSerializable());
      // the mergeFrom method ignores default values from the weatherModel passed back by the repo
      emit(state.transitionTo(const WeatherLoaded()).mergeFrom(weatherModel));
    } on NetworkException {
      emit(state.transitionTo(
        const WeatherError("Couldn't fetch weather. Is the device online?"),
      ));
    }
  }
}
