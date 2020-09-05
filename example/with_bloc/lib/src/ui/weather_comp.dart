import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubit/weather_cubit.dart';
import '../domain/models/weather_state.dart';

class _CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: TextEditingController()..text = context.bloc<WeatherCubit>().state[CityName.label],
        onSubmitted: (cityNameStr) => context.bloc<WeatherCubit>().fetchWeather(CityName(cityNameStr)),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
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

  Column _buildShowWeather(String cityName, double temperatureCelsius) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        _CityInputField(),
      ],
    );
  }

  // Widget _undoButton(UserCubit userCubit) => Center(
  //     child: RaisedButton(
  //       child: Text("Undo"),
  //       onPressed: () => userCubit.undo(),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, ImmutableModel<WeatherState>>(
          listener: (context, state) {
            final currentState = state.currentState;
            if (currentState is WeatherError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(currentState.message),
                ),
              );
            }
          },
          builder: (context, state) {
            final currentState = state.currentState;
            if (currentState is WeatherInitial) {
              return _buildInitialInput();
            } else if (currentState is WeatherLoading) {
              return _buildLoading();
            } else if (currentState is WeatherLoaded) {
              return _buildShowWeather(state[CityName.label], state['weather_data']['temperature']);
            } else {
              return _buildInitialInput();
            }
          },
        ),
      );
}
