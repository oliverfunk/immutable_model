import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/cubits/weather_cubit.dart';
import '../domain/models/weather_model.dart';

class _CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherCubit = context.watch<WeatherCubit>();

    return Column(children: [
      TextField(
        controller: TextEditingController()
          ..text = weatherCubit.state.cityName.value!,
        onSubmitted: (cityNameStr) => weatherCubit.fetchWeather(
          CityName(cityNameStr),
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
      // RaisedButton.icon(
      //   icon: Icon(Icons.arrow_back),
      //   label: Text("Last"),
      //   onPressed: uc.previousList.numberOfItems == 0
      //       ? null
      //       : () => uc.setToPrevious(),
      // ),
    ]);
  }
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
    String cityName,
    double temperatureCelsius,
    String weather,
  ) {
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
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: BlocConsumer<WeatherCubit, WeatherModel>(
        listener: (context, model) {
          final currentState = model.currentState;
          if (currentState is WeatherError) {
            ScaffoldMessenger.of(context).showSnackBar(
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
            return _buildShowWeather(
              model.cityName.value!,
              model.weatherData.value!.temperature.value!,
              model.weatherData.value!.weatherDesc.value!,
            );
          }
          return _buildInitialInput();
        },
      ),
    );
  }
}
