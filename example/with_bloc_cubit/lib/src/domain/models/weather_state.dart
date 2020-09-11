import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

class CityName extends ModelValue<CityName, String> with ValueType {
  // checks if every word is capitalised
  static final validator = (String str) => (str).split(" ").every((w) => w[0] == w[0].toUpperCase());
  static const label = "city_name";

  CityName([String defaultCityName]) : super.text(defaultCityName.trim(), validator, label);

  CityName._next(CityName previous, String value) : super.constructNext(previous, value.trim());

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}

abstract class WeatherState {
  static final model = ImmutableModel<WeatherState>(
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
    initalState: const WeatherInitial(),
  );

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
