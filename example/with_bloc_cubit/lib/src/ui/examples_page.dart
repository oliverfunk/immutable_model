import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/weather_repository.dart';

import '../domain/cubits/auth_cubit.dart';
import '../domain/cubits/user_cubit.dart';
import '../domain/cubits/weather_cubit.dart';

import 'signin_comp.dart';
import 'signin_json_disp.dart';
import 'choices_json_disp.dart';
import 'choices_comp.dart';
import 'weather_comp.dart';

class ExamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(context.read<UserCubit>()),
          ),
          BlocProvider<WeatherCubit>(
            create: (context) =>
                WeatherCubit(FakeWeatherRepository()), // should use DI
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Center(
                    child: Text("User sign in form:",
                        style: TextStyle(fontSize: 30))),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: Colors.grey.shade300))),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: SignInComponent(),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                  Expanded(
                    flex: 2,
                    child: SignInJsonDisplay(),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 5.0),
                child: Center(
                    child: Text("User choices form:",
                        style: TextStyle(fontSize: 30))),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: Colors.grey.shade300))),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: ChoicesComp(),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                  Expanded(
                    flex: 2,
                    child: ChoicesJsonDisplay(),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 5.0),
                child: Center(
                    child: Text("Fake weather getter:",
                        style: TextStyle(fontSize: 30))),
              ),
              WeatherComponent(),
            ],
          ),
        ),
      );
}
