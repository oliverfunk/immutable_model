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
          label: 'city_name',
        );

  CityName._next(CityName previous, String value)
      : super.constructNext(previous, value);

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}

class WeatherModel extends ImmutableModel<WeatherModel> {
  final CityName cityName;
  final ModelInner<WeatherDataModel> weatherData;

  WeatherModel()
      : cityName = CityName('Cape Town'),
        weatherData = ModelInner(
          WeatherDataModel(),
          label: 'weather_data',
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
        modelUpdate.getField(cityName),
        modelUpdate.getField(weatherData),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [cityName, weatherData];
}

class WeatherDataModel extends ImmutableModel<WeatherDataModel> {
  final ModelDouble temperature;
  final ModelString weatherDesc;

  WeatherDataModel([
    double temp = 0.0,
    String description = '',
  ])  : temperature = ModelDouble(temp, label: 'temperature'),
        weatherDesc = ModelString(description, label: 'weather'),
        super.initial();

  WeatherDataModel._next(
    this.temperature,
    this.weatherDesc,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  WeatherDataModel build(ModelUpdate modelUpdate) => WeatherDataModel._next(
        modelUpdate.getField(temperature),
        modelUpdate.getField(weatherDesc),
        modelUpdate,
      );

  @override
  List<ModelType<ModelType, dynamic>> get fields => [
        temperature,
        weatherDesc,
      ];
}

abstract class WeatherState extends ModelState<WeatherState> {
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
