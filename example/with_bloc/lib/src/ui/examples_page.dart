import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_bloc/src/ui/perfs_json_disp.dart';
import 'package:with_bloc/src/ui/prefs_comp.dart';

import '../data/weather_repository.dart';

import '../domain/cubit/auth_cubit.dart';
import '../domain/cubit/user_cubit.dart';
import '../domain/cubit/weather_cubit.dart';

import 'signin_comp.dart';
import 'signin_json_disp.dart';
import 'weather_comp.dart';

class ExamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(context.bloc<UserCubit>()),
          ),
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(FakeWeatherRepository()),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 2,
                  child: SignInComponent(),
                ),
                Expanded(
                  flex: 2,
                  child: signinJsonDisplay(),
                ),
              ]),
              Row(children: [
                Expanded(
                  flex: 2,
                  child: PreferancesComp(),
                ),
                Expanded(
                  flex: 2,
                  child: preferancesJsonDisplay(),
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              WeatherComponent(),
            ],
          ),
        ),
      );
}
