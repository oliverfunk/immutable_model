import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/blocs/auth/auth_bloc.dart';
import '../domain/blocs/auth/auth_state.dart';

Widget signinJsonDisplay() => BlocBuilder<AuthBloc, ImmutableModel<AuthState>>(builder: (context, model) {
      if (model.currentState is AuthLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(model.toJson())),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      } else if (model.currentState is AuthSuccess) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(model.toJson())),
            Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            )
          ],
        );
      } else if (model.currentState is AuthError) {
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
