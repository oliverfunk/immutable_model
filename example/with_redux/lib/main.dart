import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'src/app.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(App());
}
