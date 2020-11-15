import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';

class CityName extends ModelValue<CityName, String> with ValueType {
  // checks if every word is capitalized
  static final validator =
      (String str) => (str).split(" ").every((w) => w[0] == w[0].toUpperCase());

  // useful to declare the field label statically in the value type class
  static const label = "city_name";

  CityName(String cityName) : super.text(cityName.trim(), validator);

  CityName._next(CityName previous, String nextCityName)
      : super.constructNext(previous, nextCityName.trim());

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}

final weatherStateModel = ImmutableModel<WeatherState>(
  {
    CityName.label: CityName("Cape Town"),
    "weather_data": M.inner(
      {
        "temperature": M.dbl(),
        "weather": M.str(),
      },
      strictUpdates: true,
    ),
  },
  initialState: const WeatherInitial(),
);

abstract class WeatherState {
  static final cityName =
      (ImmutableModel<WeatherState> model) => model[CityName.label] as String;
  static final _weatherData = (ImmutableModel<WeatherState> model) =>
      model['weather_data'] as ModelInner;
  static final temperature = (ImmutableModel<WeatherState> model) =>
      _weatherData(model)["temperature"] as double;
  static final weather = (ImmutableModel<WeatherState> model) =>
      _weatherData(model)["weather"] as String;

  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  const WeatherLoaded();
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
}
