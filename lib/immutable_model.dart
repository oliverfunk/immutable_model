library immutable_model;

import 'dart:convert';

import 'package:immutable_model/src/imm_field_map.dart';
import 'package:immutable_model/src/immutable_model.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  ImmutableModel createImmutableModel() {
    final immModel = ImmutableModel({
      "test int": ImmutableFieldValue<int>(1, (n) => n > 0),
      "test string": ImmutableFieldValue<String>("Hello"),
      "test list": ImmutableFieldValue([1, 2, 3]),
      "inner": ImmutableFieldModel({
        "inner int": ImmutableFieldValue<int>(1, (n) => n > 0),
        "inner string": ImmutableFieldValue<String>("Hello"),
      }),
    });

    final updated = immModel.updateWith({
      "test int": 4,
      "inner": {"inner int": 100, "inner string": "NEW STRING"}
    });

    print(immModel);

//    final fuckinglit = immModel.updateWith(jsonDecode(jsonEncode(updated.asMap())));

    return immModel;
  }
}
