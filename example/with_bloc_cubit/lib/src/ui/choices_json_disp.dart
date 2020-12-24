import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/cubits/user_cubit.dart';
import '../domain/models/user_model.dart';

class ChoicesJsonDisplay extends StatelessWidget {
  const ChoicesJsonDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();

    if (userCubit.state.currentState is UserUnauthed) {
      return Center(child: Text('No user json data'));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Encoded JSON string:",
              style: TextStyle(fontWeight: FontWeight.w700)),
          Text(JsonEncoder.withIndent('  ').convert(userCubit.state.toJson())),
        ],
      );
    }
  }
}
