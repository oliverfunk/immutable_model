library immutable_model;

import 'dart:convert';

import 'package:immutable_model/src/model_values.dart';
import 'package:immutable_model/src/immutable_model.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  ImmutableModel createImmutableModel() {

    final immModel = ImmutableModel({
      "test int": ModelValue<int>(1),
      "test string": ModelValue("Hello"),
      "test infer": ModelValue(0.1),
      "test list": ModelList<int>([1,2,3], (n) => n > 0),
      "inner": ModelChild({
        "inner int": ModelValue<int>(1, (n) => n > 0),
        "inner string": ModelValue<String>("Hello"),
      }),
    });

    final updated = immModel.updateWith({
      "test int": 2,
      "inner": {"inner int": 100, "inner string": "NEW STRING"}
    });

    final js = jsonEncode({
      "test int": 2,
      "test list": [9,8,7,-1],
    });
    print("JS: $js");
    final updatedFromJSON = updated.updateWith(jsonDecode(js));

    print(immModel);
//    print(updated);
    print(updatedFromJSON);

//    final fuckinglit = immModel.updateWith();

//    return immModel;
  }
}
