import 'package:bloc/bloc.dart';

import '../../data/weather_repository.dart';
import '../models/weather_model.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<WeatherDataModel> fetchWeatherData(String cityName);
}

class WeatherCubit extends Cubit<WeatherModel> {
  final WeatherRepository _weatherRepository;
  // can safely expose this because it's immutable
  // ModelInnerList previousList;

  // WeatherCubit(this._weatherRepository)
  //     : previousList = ModelInnerList.fromIM(weatherModel),
  //       super(weatherModel);

  WeatherCubit(this._weatherRepository) : super(WeatherModel());

  // void _appendToPrevious() => previousList = previousList.append([state.inner]);
  // // will fail if numberOfItems is 0
  // void _removeLastFromPrevious() =>
  //     previousList = previousList.removeAt(previousList.numberOfItems - 1);

  // void setToPrevious() {
  //   if (previousList.numberOfItems >= 1) {
  //     emit(
  //       state
  //           .transitionTo(const WeatherLoaded())
  //           .updateWithInner(previousList.last),
  //     );
  //     _removeLastFromPrevious();
  //   }
  // }

  Future<void> fetchWeather(CityName cityName) async {
    // append if weather is loaded and fetchWeather is being called again
    if (state.currentState is WeatherLoaded) {
      // _appendToPrevious();
    }

    emit(state.updateFieldAndTransitionTo(
      const WeatherLoading(),
      field: state.cityName,
      update: cityName,
    ));

    try {
      final weatherDataModel = await _weatherRepository.fetchWeatherData(
        cityName.asSerializable(),
      );
      emit(state.updateFieldAndTransitionTo(
        const WeatherLoaded(),
        field: state.weatherData,
        update: weatherDataModel,
      ));
    } on NetworkException {
      emit(
        state.transitionTo(
          const WeatherError("Couldn't fetch weather. Is the device online?"),
        ),
      );
    }
  }
}
