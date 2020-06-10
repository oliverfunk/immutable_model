import 'dart:convert';

import 'package:immutable_model/src/model_inner.dart';
import 'package:immutable_model/src/model_primitive.dart';
import 'package:immutable_model/src/value_types/model_email.dart';

import 'model_value.dart';

void main() {
  final i = ModelInner({
    "int" : ModelPrimitive<int>(2, null, 'int'),
    "str" : ModelPrimitive<String>("Hello"),
    "dbl" : ModelPrimitive<double>(0.95, null, "dbl"),
    "email" : ModelEmail('oli.funk'),
  });

  var dbl_m = i.getFieldModel("dbl");
  dbl_m = dbl_m.next(0.85);

  final b = i.next({
    "int": 5,
    "str": (str) => str+" World",
  });

  print(b);

  final incomming = ModelEmail('new.funk');

  final c = b.next({
    "int": ModelPrimitive<int>(2, null, 'int')
  });

  print(c);
}
