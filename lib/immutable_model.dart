library immutable_model;

import 'dart:convert';

import 'src/immutable_entities/immutable_model.dart';
import 'src/model_entities/model_child.dart';
import 'src/model_entities/model_list.dart';
import 'src/model_entities/model_value.dart';


// TODO: make updates accept functions as fields in the Map and then apply the fucntion

void main(){

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

    final m2 = immModel.update({
      "test int": 2,
    });

//    print(m2);

//    final js = jsonEncode({
//      "test intt": 2,
//      "test list": [9,8,7,-1],
//      "test valid list": [9,8,7,1],
//    });
//    final updatedFromJSON = immModel.updateFrom(jsonDecode(js));
  }

class ValueTypeException implements Exception {
  final Type expected;
  final Type received;
  final dynamic value;

  ValueTypeException(this.expected, this.received, this.value);

  @override
  String toString() => 'Expected $expected but got $received: $value';
}