import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_bloc/src/ui/login_comp.dart';
import 'package:with_bloc/src/ui/weather_comp.dart';

import '../data/weather_repository.dart';

import '../domain/cubit/auth_cubit.dart';
import '../domain/cubit/user_cubit.dart';
import '../domain/cubit/weather_cubit.dart';

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
        child: Column(
          children: [
            LoginComponent(),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            WeatherComponent(),
          ],
        ),
      );
}
