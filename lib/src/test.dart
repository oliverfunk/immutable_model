import 'package:immutable_model/src/immutable_model.dart';
import 'package:immutable_model/src/model_primitive.dart';
import 'package:immutable_model/src/model_value.dart';

// TODO: make updates accept functions as fields in the Map and then apply the fucntion
// TODO: write tests for seriliaszation, value getting and updateing etc.
// TODO: benchmark asMap, toMap methods for model
// todo: write methods for list that let you update an elemnt at the idx
// todo: maybe you want some lists that hold {} with no validation, or with complete validation (i.e the whole map must be there) also makes me think about model and it's update method.
// todo: equality for entities


void main(){

  final model_init = ImmutableModel({
    "test int" : ModelPrimitive<int>(6, (i) => i > 0 ? i : throw Error()),
    "test string" : ModelPrimitive<String>("Hello"),
  });

  final model_1 = model_init.update({"test int": 10});
//  final model_2 = model_init.update({"test int": -10});
  final model_3 = model_init.update({"test string": "World"});
  final model_4 = model_init.update({"test string": 12});



  print("model_init: $model_init");
  print("model_1: $model_1");
  print("model_3: $model_3");
}

