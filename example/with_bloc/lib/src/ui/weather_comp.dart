import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/blocs/weather/weather_bloc.dart';
import '../domain/blocs/weather/weather_event.dart';
import '../domain/blocs/weather/weather_state.dart';

WeatherBloc _weatherBloc(BuildContext context) => context.bloc<WeatherBloc>();

class _CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextField(
        controller: TextEditingController()
          ..text = WeatherState.cityName(_weatherBloc(context).state),
        onSubmitted: (cityNameStr) =>
            _weatherBloc(context).add(FetchWeather(CityName(cityNameStr))),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      );
}

class WeatherComponent extends StatelessWidget {
  Widget _buildInitialInput() {
    return Center(
      child: _CityInputField(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column _buildShowWeather(
      String cityName, double temperatureCelsius, String weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          cityName,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "$weather - ${temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 50),
        ),
        _CityInputField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: BlocConsumer<WeatherBloc, ImmutableModel<WeatherState>>(
          listener: (context, model) {
            final currentState = model.currentState;
            if (currentState is WeatherError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(currentState.message),
                ),
              );
            }
          },
          builder: (context, model) {
            final currentState = model.currentState;
            if (currentState is WeatherInitial) {
              return _buildInitialInput();
            } else if (currentState is WeatherLoading) {
              return _buildLoading();
            } else if (currentState is WeatherLoaded) {
              return _buildShowWeather(WeatherState.cityName(model),
                  WeatherState.temperature(model), WeatherState.weather(model));
            }

            return _buildInitialInput();
          },
        ),
      );
}
