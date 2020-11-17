import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/app_state.dart';
import '../domain/redux/weather/weather_model.dart';
import '../domain/redux/weather/weather_thunks.dart';

Store<AppState> _store(BuildContext context) =>
    StoreProvider.of<AppState>(context);

class _CityInputField extends StatelessWidget {
  Widget _cityNameTextInput(BuildContext context) => TextField(
        controller: TextEditingController()
          ..text = WeatherState.cityName(_store(context).state.weather),
        onSubmitted: (cityNameStr) =>
            _store(context).dispatch(fetchWeather(CityName(cityNameStr))),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(children: [
        _cityNameTextInput(context),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        RaisedButton.icon(
          icon: Icon(Icons.arrow_back),
          label: Text("Last"),
          onPressed: numberOfPrevious() == 0
              ? null
              : () => _store(context).dispatch(setToPreviousWeather()),
        ),
      ]);
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
        child: StoreConnector<AppState, ImmutableModel<WeatherState>>(
          converter: (store) => store.state.weather,
          onWillChange: (previousModel, newModel) {
            final currentState = newModel.currentState;
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
