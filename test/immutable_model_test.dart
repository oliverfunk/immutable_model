import 'package:test/test.dart';

import 'package:immutable_model/immutable_model.dart';

void main() {

  group("model creation", (){
    test("Test model definition", (){
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
      });
    });
  });

  group("model updates and resets", (){

  });

  group("model value retrieval", (){

  });

  group("model creation", (){

  });

  group("model JSON handling", (){

  });

  group("model state restore", (){

  });

  group("model state restore", (){

  });

}
