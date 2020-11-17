import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../../../data/weather_repository.dart';
import 'weather_model.dart';
import 'weather_event.dart';

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<ImmutableModel<WeatherState>> fetchWeather(String cityName);
}

class WeatherBloc extends Bloc<WeatherEvent, ImmutableModel<WeatherState>> {
  final WeatherRepository _weatherRepository;
  // can safely expose this because it's immutable
  ModelInnerList previousList;

  WeatherBloc(this._weatherRepository)
      : previousList = ModelInnerList.fromIM(weatherModel),
        super(weatherModel);

  void _appendToPrevious() => previousList = previousList.append([state.inner]);
  // will fail if numberOfItems is 0
  ModelInner _popLastFromPrevious() {
    final returnInner = previousList.last;
    previousList = previousList.removeAt(previousList.numberOfItems - 1);
    return returnInner;
  }

  @override
  Stream<ImmutableModel<WeatherState>> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is FetchWeather) {
      // append if weather is loaded and fetchWeather is being called again
      if (state.currentState is WeatherLoaded) {
        _appendToPrevious();
      }
      yield state.transitionToAndUpdate(
        const WeatherLoading(),
        {
          CityName.label: event.cityName,
        },
      );
      try {
        final weatherModel = await _weatherRepository.fetchWeather(
          event.cityName.asSerializable(),
        );
        // the mergeFrom method ignores default values from the weatherModel passed back by the repo
        yield state.transitionTo(const WeatherLoaded()).mergeFrom(weatherModel);
      } on NetworkException {
        yield state.transitionTo(
          const WeatherError("Couldn't fetch weather. Is the device online?"),
        );
      }
    } else if (event is SetToPrevious) {
      if (previousList.numberOfItems >= 1) {
        yield state
            .transitionTo(const WeatherLoaded())
            .updateWithInner(_popLastFromPrevious());
      }
    }
  }
}
