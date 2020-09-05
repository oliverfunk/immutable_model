import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubit/user_cubit.dart';
import '../domain/models/user_state.dart';

Widget preferancesJsonDisplay() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(builder: (context, state) {
      if (state.currentState is UserUnauthed) {
        return Column(
          children: [
            Text("User not auth'd yet"),
          ],
        );
      } else {
        return Text(state.toJson().toString());
      }
    });
