import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/cubits/auth_cubit.dart';
import '../domain/models/auth_model.dart';

class SignInJsonDisplay extends StatelessWidget {
  const SignInJsonDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();

    if (authCubit.state.currentState is AuthLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Encoded JSON string:",
              style: TextStyle(fontWeight: FontWeight.w700)),
          Text(
            JsonEncoder.withIndent('  ').convert(
              authCubit.state.toJson(),
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    } else if (authCubit.state.currentState is AuthSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Encoded JSON string:",
              style: TextStyle(fontWeight: FontWeight.w700)),
          Text(
            JsonEncoder.withIndent('  ').convert(
              authCubit.state.toJson(),
            ),
          ),
          Center(
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          )
        ],
      );
    } else if (authCubit.state.currentState is AuthError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign in failed - try again",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Center(
            child: Icon(
              Icons.clear,
              color: Colors.red,
            ),
          )
        ],
      );
    } else {
      return Center(child: Text('No auth json data'));
    }
  }
}
