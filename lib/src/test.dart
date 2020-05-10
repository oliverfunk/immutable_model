import 'package:immutable_model/src/immutable_model.dart';
import 'package:immutable_model/src/model_list.dart';
import 'package:immutable_model/src/model_primitive.dart';

// TODO: make updates accept functions as fields in the Map and then apply the fucntion
// TODO: write tests for seriliaszation, value getting and updateing etc.
// todo: write methods for list that let you update an elemnt at the idx
// todo: maybe you want some lists that hold {} with no validation, or with complete validation (i.e the whole map must be there) also makes me think about model and it's update method.
// todo: equality for entities + model

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

  print("model_init: $model_init");
  print("model_1: $model_1");
  print("model_2: $model_2");
  print("cache'd 1: ${model_2.restoreTo(3) == model_2.reset()}");
}
