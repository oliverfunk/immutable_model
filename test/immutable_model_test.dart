import 'dart:convert';
import 'package:test/test.dart';

import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';
//final i = ModelInner({
//  "int" : ModelPrimitive<int>(2),
//  "str" : ModelPrimitive<String>("Hello"),
//  "dbl" : ModelPrimitive<double>(0.95),
//  "email" : ModelEmail('oli.funk'),
//});
//
//var dbl_m = i.getFieldModel("dbl");
//dbl_m = dbl_m.next(0.85);
//
//final b = i.next({
//  "int": 5,
//  "str": (str) => str+" World",
//  "dbl": dbl_m
//});
//
//final incomming = ModelEmail('new.funk');
//
//final c = b.next({
//  "email": incomming
//});
//
//print(c);

//final model_init = ImmutableModel({
//  "test int": ModelPrimitive<int>(6, (i) => i > 0 ? i : throw Error()),
//  "test string": ModelPrimitive<String>("Hello"),
//  "test list": ModelList<int>([1, 2, 3], (i) => i > 0),
//  "test inner": ImmutableModel({
//    "test inner int": ModelPrimitive<int>(66, (i) => i > 0 ? i : throw Error()),
//    "test inner string": ModelPrimitive<String>("Hello inner"),
//  }),
//  "test valid list": ModelValidatedList(
//      ImmutableModel({
//        "list model int": ModelPrimitive<int>(null, (i) => i > 0 ? i : throw Error()),
//        "list model string": ModelPrimitive<String>(),
//      }),
//      [
//        {"list model int": 1, "list model string": "Hello"}
//      ], true, false)
//}, 5);
//
//// value setting
//final model_1 = model_init.update({
//  "test int": 1,
//  "test inner": {"test inner int": 100},
//  "test valid list": [
//    {"list model string": "Sick"}
//  ]
//});
//final model_2 = model_1.update({"test int": 2}).update({"test string": "next"});
//final model3 = model_2.updateFieldsWith({
//  "test int": (i) => i + 5,
//  "test string": (s) => s + " this was added",
//});
//
//final mod3from = model_init.updateFrom(jsonDecode(jsonEncode(model3.asSerializable())));
//
//print("model_init: $model_init");
//print("model_1: ${model_1}");
//print("model_1: ${model_1.value}");
//print("model_2: ${model_2.asSerializable()}");
//print("modfrom: $mod3from");
//print("cache'd 1: ${model_2.restoreTo(3) == model_2.reset()}");
//
//
//
////  final cmv = model3.getFieldModel("test valid list") as ModelList;
//
//final mod_rest = model3.reset();
//final mod3back = mod_rest.restoreTo(1);
//
//print(model3 == mod3back);
//print(model_init == mod_rest);

//final model_init = ImmutableModel({
//  "test int": ModelPrimitive<int>(6, (i) => i > 0 ? i : throw Error()),
//  "test string": ModelPrimitive<String>("Hello"),
//  "test list": ModelList<int>([1, 2, 3], (i) => i > 0),
//  "test inner": ImmutableModel({
//    "test inner int": ModelPrimitive<int>(66, (i) => i > 0 ? i : throw Error()),
//    "test inner string": ModelPrimitive<String>("Hello inner"),
//  }),
//  "test valid list": ModelValidatedList(
//      ImmutableModel({
//        "list model int": ModelPrimitive<int>(null, (i) => i > 0 ? i : throw Error()),
//        "list model string": ModelPrimitive<String>(),
//      }),
//      [
//        {"list model int": 1, "list model string": "Hello"}
//      ], true, false)
//});

//enum TestEnum {
//  First, Second, Third
//}

//test("test misc", (){
//print(TestEnum.values);
//final mod_enum = ImmutableModel({"enum": ModelEnum(ModelEnum.fromClass<TestEnum>(TestEnum.values), ModelEnum.fromEnum(TestEnum.First))});
//final next_mod = mod_enum.update({"enum": ModelEnum.fromEnum(TestEnum.Third)});
//
//final jEnc = jsonEncode(next_mod.toJson());
//print(jEnc);
//print(jsonDecode(jEnc));
//print(mod_enum.fromJson(jsonDecode(jEnc)));
//
//
//});

// todo: test each model_* without using imm_mod

enum TestAnotherEnum { AnFirst, AnSecond, Third }

void main() {
  test("test misc", () {
    final mod = ImmutableModel({
      'enum': M.enm<TestAnotherEnum>(TestAnotherEnum.values, TestAnotherEnum.AnFirst),
      'bool': M.bl(true),
      'int': M.nt(6, (i) => i > 0),
      'dt beg': M.dt(DateTime.now()),
      'dt end': M.dt(DateTime.now().add(Duration(seconds: 100))),
      'bool list': M.blList([true, false, true]),
      'str': M.str("Oliver"),
      'eml': M.email(),
      'mvList': M.mvList(
          ImmutableModel({
            'int': M.nt(),
            'fn': M.str(),
            'sn': M.str(),
          }),
          [
            {
              'int': 10,
              'fn': 'Oliver',
              'sn': 'Funk',
            }
          ],
          false)
    }, (stateMap) => (stateMap['dt beg'].value as DateTime).isBefore(stateMap['dt end'].value as DateTime));

    final tomerge = ImmutableModel({
      'dt end': M.dt(DateTime.now().add(Duration(seconds: 100))),
    });

    final mmod = mod.mergeModel(tomerge).update({
      'dt end': DateTime.now().add(Duration(seconds: 100)),
    });

    final jenc = jsonEncode(mmod.toJson());
    print(jenc);
    print(jsonDecode(jenc));
    print(mmod.fromJson(jsonDecode(jenc)));
  });

//  group("Model object tests", () {
//    test("Basic model primitive initialisation tests", () {
//      final test_int_null_init = ModelPrimitive<int>();
//      expect(test_int_null_init.value, null);
//
//      final test_int_null_1 = test_int_null_init.next(1);
//      expect(test_int_null_1.value, 1);
//
//      final test_int_null_2 = test_int_null_1.next(2);
//      expect(test_int_null_2.value, 2);
//
//      final test_int_null_reset = test_int_null_2.next(null);
//      expect(test_int_null_reset.value, null);
//
//      final test_int_default_init = ModelPrimitive<int>(5);
//      expect(test_int_default_init.value, 5);
//
//      final test_int_default_1 = test_int_default_init.next(1);
//      expect(test_int_null_1.value, 1);
//
//      final test_int_default_2 = test_int_default_1.next(2);
//      expect(test_int_null_2.value, 2);
//
//      final test_int_default_reset = test_int_default_2.next(null);
//      expect(test_int_default_reset.value, 5);
//    });
//  });
//
//  group("model definition", () {
//    test("Basic empty model", () {
//      final model = ImmutableModel({
//        "bool": ModelPrimitive<bool>(),
//        "int": ModelPrimitive<int>(),
//        "double": ModelPrimitive<double>(),
//        "string": ModelPrimitive<String>(),
//        "datetime": ModelPrimitive<DateTime>(),
//      });
//
//      expect(model.asMap(), {
//        "bool": null,
//        "int": null,
//        "double": null,
//        "string": null,
//        "datetime": null,
//      });
//    });
//
//    test("Basic model with default values", () {
//      final model = ImmutableModel({
//        "bool": ModelPrimitive<bool>(false),
//        "int": ModelPrimitive<int>(6),
//        "double": ModelPrimitive<double>(0.95),
//        "string": ModelPrimitive<String>("Default"),
//        "datetime": ModelPrimitive<DateTime>(DateTime(2020, 6, 1)),
//      });
//
//      expect(model.asMap(), {
//        "bool": false,
//        "int": 6,
//        "double": 0.95,
//        "string": "Default",
//        "datetime": DateTime(2020, 6, 1),
//      });
//    });
//
//    test("Basic model with mixed defaults and validators", () {
//      final model = ImmutableModel({
//        "bool": ModelPrimitive<bool>(false),
//        "int": ModelPrimitive<int>(6, (i) => i > 0),
//        "double": ModelPrimitive<double>(null),
//        "string": ModelPrimitive<String>("Default"),
//        "datetime": ModelPrimitive<DateTime>(
//            DateTime(2020, 6, 1), (dt) => dt.isAfter(DateTime(2020, 1, 1))),
//      });
//
//      expect(model.asMap(), {
//        "bool": false,
//        "int": 6,
//        "double": null,
//        "string": "Default",
//        "datetime": DateTime(2020, 6, 1),
//      });
//    });
//  });

  group("model updates and resets", () {});

  group("model value retrieval", () {});

  group("model creation", () {});

  group("model JSON handling", () {});

  group("model state restore", () {});

  group("model state restore", () {});
}
