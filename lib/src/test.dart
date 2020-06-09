import 'dart:convert';

import 'package:immutable_model/src/model_inner.dart';
import 'package:immutable_model/src/model_primitive.dart';

void main() {
  final i = ModelInner({
    "int" : ModelPrimitive<int>(2),
    "str" : ModelPrimitive<String>("Hello"),
  });

  FieldUpdater fu = (str) => str+"YES";

  final b = i.next({
    "int": 5,
    "str": (str) => str+"YES",
  });

  print(b);
}
