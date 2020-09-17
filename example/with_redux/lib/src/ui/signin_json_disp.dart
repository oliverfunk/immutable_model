import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../domain/app_state.dart';
import '../domain/redux/auth/auth_state.dart';

Widget signinJsonDisplay() => StoreConnector<AppState, AuthState>(
    converter: (store) => store.state.authModel.currentState,
    builder: (context, state) {
      if (state is AuthLoading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(StoreProvider.of<AppState>(context).state.authModel.toJson())),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      } else if (state is AuthSuccess) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(StoreProvider.of<AppState>(context).state.authModel.toJson())),
            Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            )
          ],
        );
      } else if (state is AuthError) {
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
