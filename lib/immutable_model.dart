library immutable_model;

import 'dart:convert';

import 'package:immutable_model/src/model_values/model_value.dart';
import 'package:immutable_model/src/immutable_model.dart';

import 'src/model_values/model_child.dart';
import 'src/model_values/model_list.dart';

/// A Calculator.
class Calculator {


  // tood: do compound list


  ImmutableModel createImmutableModel() {

    final immModel = ImmutableModel({
      "test int": ModelPrimitiveValue<int>(1),
      "test string": ModelPrimitiveValue("Hello"),
      "test infer": ModelPrimitiveValue(0.1),
      "test date": ModelValue<DateTime>((dt)=> dt.toIso8601String(), (s) => DateTime.parse(s), DateTime.now()),
      "test prim list": ModelPrimitiveList<int>([1,2,3]),
      "test valid datetime list": ModelList<DateTime>((dt)=> dt.toIso8601String(), (s) => DateTime.parse(s), [DateTime.now()], null, true),
      "inner": ModelChild({
        "inner int": ModelPrimitiveValue<int>(1, (n) => n > 0),
        "inner string": ModelPrimitiveValue<String>("Hello"),
      }),
    });

//    final js = jsonEncode({
//      "test intt": 2,
//      "test list": [9,8,7,-1],
//      "test valid list": [9,8,7,1],
//    });
//    final updatedFromJSON = immModel.updateFrom(jsonDecode(js));

    print(immModel);
    print(immModel.asSerializable());
    print(immModel.updateFrom(immModel.asSerializable()));
    print(immModel.resetAll());

    print("");
    print(immModel.getValue("test date"));
    print(immModel.getValue("test date").runtimeType);
//    print(updated);
//    print(updatedFromJSON);
//    print(updatedFromJSON.resetAll());

//    final fuckinglit = immModel.updateWith();

//    return immModel;
  }
}
