import 'package:immutable_model/src/immutable_model.dart';
import 'package:immutable_model/src/model_list.dart';
import 'package:immutable_model/src/model_primitive.dart';

// TODO: write tests for seriliaszation, value getting and updateing etc.
// todo: maybe you want some lists that hold {} with no validation, or with complete validation (i.e the whole map must be there) also makes me think about model and it's update method.
// todo: |-> updateComplete(Map) in ImmMod to ensure valid _structural_ update

void main() {
  final model_init = ImmutableModel({
    "test int": ModelPrimitive<int>(6, (i) => i > 0 ? i : throw Error()),
    "test string": ModelPrimitive<String>("Hello"),
    "test list": ModelList<int>([1, 2, 3], (i) => i > 0),
    "test inner": ImmutableModel({
      "test inner int": ModelPrimitive<int>(66, (i) => i > 0 ? i : throw Error()),
      "test inner string": ModelPrimitive<String>("Hello inner"),
    }),
    "test comp list": ModelValidatedList(
        ImmutableModel({
          "list model int": ModelPrimitive<int>(null, (i) => i > 0 ? i : throw Error()),
          "list model string": ModelPrimitive<String>(),
        }),
        [
          {"list model int": 1, "list model string": "Hello"}
        ])
  });

  // value setting
  final model_1 = model_init.update({
    "test int": 1,
    "test inner": {"test inner int": 100},
    "test comp list": [
      {"list model int": 100, "list model string": "Sick"}
    ]
  });
  final model_2 = model_1.update({"test int": 2}).update({"test string": "next"});
  final model3 = model_2.updateFieldsWith({
    "test int": (i) => i + 5,
    "test string": (s) => s + " this was added",
  });

//  print("model_init: $model_init");
//  print("model_1: ${model_1}");
//  print("model_1: ${model_1.value}");
//  print("model_2: ${model_2.asSerializable()}");
//  print("cache'd 1: ${model_2.restoreTo(3) == model_2.reset()}");
  print(model3);
}
