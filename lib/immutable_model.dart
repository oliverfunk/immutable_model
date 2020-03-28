library immutable_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/model_entities/model.dart';
import 'package:immutable_model/src/model_entities/model_list.dart';

import 'src/model_entities/model_value.dart';

// TODO: make updates accept functions as fields in the Map and then apply the fucntion
// TODO: write tests for seriliaszation, value getting and updateing etc.
// TODO: benchmark asMap, toMap methods for model
// todo: write methods for list that let you update an elemnt at the idx
// todo: maybe you want some lists that hold {} with no validation, or with complete validation (i.e the whole map must be there) also makes me think about model and it's update method.
// todo: equality for entities

void main() {
  final immModel = Model({
    "cl": ModelCompositeList(Model({
      "l s": ModelPrimitiveValue<String>(),
      "l i": ModelPrimitiveValue<int>(null, (i) => i > 0 ? i : throw Exception("FOK JOU")),
    })),
      "test string": ModelPrimitiveValue<String>("Hello"),
      "test infer": ModelPrimitiveValue<double>(0.1),
      "test date": ModelValue<DateTime>((dt)=> dt.toIso8601String(), (s) => DateTime.parse(s), DateTime.now()),
      "test prim list": ModelPrimitiveList<int>([1,2,3]),
      "test valid datetime list": ModelList<DateTime>((dt)=> dt.toIso8601String(), (s) => DateTime.parse(s), [DateTime.now()], null, true),
      "inner": Model({
        "inner int": ModelPrimitiveValue<int>(1, (n) => n > 0),
        "inner string": ModelPrimitiveValue<String>("Hello"),
      }),
  });


  print(immModel);
  final m2 = immModel.update({
    "cl": [{
      "l s": "HOLY FUCK",
      "l i": 10,
    },
      {
        "l i": 1000,
      },

    ]
  });


  print(m2.getEntity("cl"));



    final js = jsonDecode(jsonEncode({
      "test bool": true,
      "test double": 0.1,
      "test int": 2,
      "test list": [9,8,7,-1],
      "test valid list": [9,8,7,1],
    }));
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
