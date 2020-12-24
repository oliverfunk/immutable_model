import 'package:immutable_model/immutable_model.dart';

class CityName extends ModelValueType<CityName, String> with ValueType {
  // checks if every word is capitalized
  static bool validator(String cityName) =>
      (cityName).split(" ").every((w) => w[0] == w[0].toUpperCase());

  CityName(
    String cityNameString,
  ) : super.initial(
          cityNameString,
          validator: validator,
          fieldLabel: 'city_name',
        );

  CityName._next(CityName previous, String value)
      : super.constructNext(previous, value);

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}

class WeatherModel extends ImmutableModel<WeatherModel, WeatherState> {
  final CityName cityName;
  final ModelInner<WeatherDataModel> weatherData;

  WeatherModel()
      : cityName = CityName('Cape Town'),
        weatherData = ModelInner(
          WeatherDataModel(),
          fieldLabel: 'weather_data',
        ),
        super.initial(
          initialState: const WeatherInitial(),
        );

  WeatherModel._next(
    this.cityName,
    this.weatherData,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  WeatherModel build(ModelUpdate modelUpdate) => WeatherModel._next(
        modelUpdate.nextField(cityName),
        modelUpdate.nextField(weatherData),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [cityName, weatherData];
}

class WeatherDataModel extends ImmutableModel<WeatherDataModel, dynamic> {
  final ModelDouble temperature;
  final ModelString weatherDesc;

  WeatherDataModel([
    double temp = 0.0,
    String description = '',
  ])  : temperature = ModelDouble(temp, fieldLabel: 'temperature'),
        weatherDesc = ModelString(description, fieldLabel: 'weather'),
        super.initial();

  WeatherDataModel._next(
    this.temperature,
    this.weatherDesc,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  WeatherDataModel build(ModelUpdate modelUpdate) => WeatherDataModel._next(
        modelUpdate.nextField(temperature),
        modelUpdate.nextField(weatherDesc),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [
        temperature,
        weatherDesc,
      ];
}

abstract class WeatherState {
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
