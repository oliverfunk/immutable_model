import 'package:redux/redux.dart';
import 'package:immutable_model/immutable_model.dart';

import 'weather_state.dart';
import 'weather_action.dart';

class WeatherReducer extends ReducerClass<ImmutableModel<WeatherState>> {
  ImmutableModel<WeatherState> call(model, action) {
    if (action is FetchWeatherBegin) {
      return model.transitionToAndUpdate(
        const WeatherLoading(),
        {
          CityName.label: action.cityName,
        },
      );
    } else if (action is FetchWeatherSuccess) {
      return model.transitionTo(const WeatherLoaded()).mergeFrom(action.returnedModel);
    } else if (action is FetchWeatherFailure) {
      return model.transitionTo(const WeatherError("Couldn't fetch weather. Is the device online?"));
    }

    return model;
  }
}
