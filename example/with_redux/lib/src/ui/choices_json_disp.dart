import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../domain/app_state.dart';
import '../domain/redux/user/user_state.dart';

Widget choicesJsonDisplay() => StoreConnector<AppState, UserState>(
    converter: (store) => store.state.userModel.currentState,
    builder: (context, state) {
      if (state is UserUnauthed) {
        return Center(child: Text('No user json data'));
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Encoded JSON string:", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(JsonEncoder.withIndent('  ').convert(StoreProvider.of<AppState>(context).state.userModel.toJson())),
          ],
        );
      }
    });
