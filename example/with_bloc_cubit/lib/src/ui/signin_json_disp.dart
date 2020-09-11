import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubits/auth_cubit.dart';
import '../domain/models/auth_state.dart';

Widget signinJsonDisplay() => BlocBuilder<AuthCubit, ImmutableModel<AuthState>>(builder: (context, state) {
      if (state.currentState is AuthLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(state.toJson())),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      } else if (state.currentState is AuthSuccess) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(state.toJson())),
            Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            )
          ],
        );
      } else if (state.currentState is AuthError) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sign in failed - try again", style: TextStyle(fontWeight: FontWeight.w700)),
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
    });
