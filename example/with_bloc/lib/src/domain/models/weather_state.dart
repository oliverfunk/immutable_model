import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

// test what happens when model goes invalid

class CityName extends ModelPrimitive<String> {
  // checks if check word is capitalised
  static final validator = (str) => (str as String).split(" ").every((w) => w[0] == w[0].toUpperCase());
  static const label = "city_name";

  CityName([String value]) : super.text(value, validator, label);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is CityName;
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
