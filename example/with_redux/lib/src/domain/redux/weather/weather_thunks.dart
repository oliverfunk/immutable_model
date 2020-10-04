import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:with_redux/src/domain/redux/weather/weather_action.dart';

import '../../../data/weather_repository.dart';
import '../../app_state.dart';
import 'weather_state.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

// not the best way to do this, should DI the repo in somehow.
final WeatherRepository _weatherRepository = FakeWeatherRepository();

ThunkAction<AppState> fetchWeather(CityName cityName) {
  return (Store<AppState> store) async {
    store.dispatch(FetchWeatherBegin(cityName));
    try {
      final weatherModel =
          await _weatherRepository.fetchWeather(cityName.asSerializable());
      store.dispatch(FetchWeatherSuccess(weatherModel));
    } on NetworkException {
      store.dispatch(FetchWeatherFailure());
    }
  };
}
