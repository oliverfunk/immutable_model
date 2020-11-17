import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/blocs/user/user_bloc.dart';
import '../domain/blocs/user/user_model.dart';

Widget choicesJsonDisplay() =>
    BlocBuilder<UserBloc, ImmutableModel<UserState>>(builder: (context, model) {
      if (model.currentState is UserUnauthed) {
        return Center(child: Text('No user json data'));
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:",
                style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(model.toJson())),
          ],
        );
      }
    });
