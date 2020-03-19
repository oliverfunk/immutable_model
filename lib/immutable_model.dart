library immutable_model;

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
      "inner": ModelChild({
        "inner int": ModelValue<int>(1, (n) => n > 0),
        "inner string": ModelValue<String>("Hello"),
      }),
    });

    final updated = immModel.updateWith({
      "test int": 2,
      "inner": {"inner int": 100, "inner string": "NEW STRING"}
    });

    final updated2 = updated.updateWith({
      "test int": 5,
    });

    print(immModel);
    print(updated);
    print(updated2);

//  print(immModel);

//    final fuckinglit = immModel.updateWith(jsonDecode(jsonEncode(updated.asMap())));

//    return immModel;
  }
}
