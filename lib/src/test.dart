import 'dart:convert';

import 'package:immutable_model/src/immutable_model.dart';
import 'package:immutable_model/src/model_list.dart';
import 'package:immutable_model/src/model_primitive.dart';



void main() {
  final model_init = ImmutableModel({
    "test int": ModelPrimitive<int>(6, (i) => i > 0 ? i : throw Error()),
    "test string": ModelPrimitive<String>("Hello"),
    "test list": ModelList<int>([1, 2, 3], (i) => i > 0),
    "test inner": ImmutableModel({
      "test inner int": ModelPrimitive<int>(66, (i) => i > 0 ? i : throw Error()),
      "test inner string": ModelPrimitive<String>("Hello inner"),
    }),
    "test valid list": ModelValidatedList(
        ImmutableModel({
          "list model int": ModelPrimitive<int>(null, (i) => i > 0 ? i : throw Error()),
          "list model string": ModelPrimitive<String>(),
        }),
        [
          {"list model int": 1, "list model string": "Hello"}
        ], true, false)
  }, 5);

  // value setting
  final model_1 = model_init.update({
    "test int": 1,
    "test inner": {"test inner int": 100},
    "test valid list": [
      {"list model string": "Sick"}
    ]
  });
  final model_2 = model_1.update({"test int": 2}).update({"test string": "next"});
  final model3 = model_2.updateFieldsWith({
    "test int": (i) => i + 5,
    "test string": (s) => s + " this was added",
  });

  final mod3from = model_init.updateFrom(jsonDecode(jsonEncode(model3.asSerializable())));

  print("model_init: $model_init");
  print("model_1: ${model_1}");
  print("model_1: ${model_1.value}");
  print("model_2: ${model_2.asSerializable()}");
  print("modfrom: $mod3from");
  print("cache'd 1: ${model_2.restoreTo(3) == model_2.reset()}");



//  final cmv = model3.getFieldModel("test valid list") as ModelList;

  final mod_rest = model3.reset();
  final mod3back = mod_rest.restoreTo(1);

  print(model3 == mod3back);
  print(model_init == mod_rest);
}
