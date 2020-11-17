import 'package:immutable_model/model_types.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:with_redux/src/domain/redux/weather/weather_action.dart';

import '../../../data/weather_repository.dart';
import '../../app_state.dart';
import 'weather_model.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

// not the best way to do this, should DI the repo in somehow.
final WeatherRepository _weatherRepository = FakeWeatherRepository();

ModelInnerList _previousList = ModelInnerList.fromIM(weatherModel);

int numberOfPrevious() => _previousList.numberOfItems;

void _appendToPrevious(ImmutableModel<WeatherState> wModel) =>
    _previousList = _previousList.append([wModel.inner]);

// will fail if numberOfItems is 0
ModelInner _popLastFromPrevious() {
  final returnInner = _previousList.last;
  _previousList = _previousList.removeAt(_previousList.numberOfItems - 1);
  return returnInner;
}

ThunkAction<AppState> fetchWeather(CityName cityName) {
  return (Store<AppState> store) async {
    // append if weather is loaded and fetchWeather is being called again
    if (store.state.weather.currentState is WeatherLoaded) {
      _appendToPrevious(store.state.weather);
    }

    store.dispatch(FetchWeatherBegin(cityName));
    try {
      final weatherModel = await _weatherRepository.fetchWeather(
        cityName.asSerializable(),
      );
      store.dispatch(FetchWeatherSuccess(weatherModel));
    } on NetworkException {
      store.dispatch(FetchWeatherFailure());
    }
  };
}

ThunkAction<AppState> setToPreviousWeather() {
  return (Store<AppState> store) {
    store.dispatch(SetPreviousWeather(_popLastFromPrevious()));
  };
}
