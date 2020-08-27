import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubit/auth_cubit.dart';
import '../domain/models/auth_state.dart';

Widget signinJsonDisplay() => BlocBuilder<AuthCubit, ImmutableModel<AuthState>>(builder: (context, state) {
      if (state.currentState is AuthLoading) {
        return Column(
          children: [
            Text(state.toJson().toString()),
            CircularProgressIndicator(),
          ],
        );
      } else if (state.currentState is AuthSuccess) {
        return Column(
          children: [
            Text(state.toJson().toString()),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            )
          ],
        );
      } else {
        return Text('Nothing yet');
      }
    });
