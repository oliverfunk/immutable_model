import 'package:flutter/material.dart';

import 'ui/examples_page.dart';

class App extends StatelessWidget {
  static const String _title =
      "immutable_model example with Redux and Redux Thunk";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: ExamplesPage(),
      ),
    );
  }
}
