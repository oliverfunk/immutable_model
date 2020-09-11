import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubits/user_cubit.dart';
import '../domain/models/user_state.dart';

Widget preferancesJsonDisplay() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(builder: (context, state) {
      if (state.currentState is UserUnauthed) {
        return Center(child: Text('No user json data'));
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(state.toJson())),
          ],
        );
      }
    });
