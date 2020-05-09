library immutable_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/immutable_model.dart';

// TODO: make updates accept functions as fields in the Map and then apply the fucntion
// TODO: write tests for seriliaszation, value getting and updateing etc.
// TODO: benchmark asMap, toMap methods for model
// todo: write methods for list that let you update an elemnt at the idx
// todo: maybe you want some lists that hold {} with no validation, or with complete validation (i.e the whole map must be there) also makes me think about model and it's update method.
// todo: equality for entities

void main() {

  final model_inital = ImmutableModel({

  });


}

class ValueTypeException implements Exception {
  final Type expected;
  final Type received;
  final dynamic value;

  ValueTypeException(this.expected, this.received, this.value);

  @override
  String toString() => 'Expected $expected but got $received: $value';
}
