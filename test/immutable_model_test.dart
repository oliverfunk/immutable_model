import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';
import 'package:test/test.dart';

// todo: test each model_* without using imm_mod

enum TestAnotherEnum { AnFirst, AnSecond, Third }

class CityName extends ModelValue<CityName, String> with ValueType {
  // checks if every word is capitalised
  static final validator = (String str) => (str).split(" ").every((w) => w[0] == w[0].toUpperCase());
  static const label = "city_name";

  CityName([String defaultCityName]) : super.text(defaultCityName.trim(), validator, label);

  CityName._next(CityName previous, String value) : super.constructNext(previous, value.trim());

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}

void main() {
  test("test misc", () {
    final cn = CityName('asd');

    // final model = ImmutableModel(
    //   {
    //     "email": M.email(
    //       defaultEmail: "oli.funk@gmail.com",
    //     ),
    //     "password": M.password(),
    //     "chosen_values": M.inner({
    //       "a_str": M.str(
    //         initialValue: "Hello M!",
    //       ),
    //       "validated_number": M.nt(
    //         initialValue: 0,
    //         validator: (n) => n >= 0,
    //       ),
    //       "entered_double": M.dbl(
    //         initialValue: 13 / 7,
    //       ),
    //       "chosen_bool": M.bl(
    //         initialValue: true,
    //       ),
    //       "date_begin": M.dt(
    //         initialValue: DateTime.now(),
    //       ),
    //       "date_end": M.dt(
    //         initialValue: DateTime.now().add(Duration(seconds: 100)),
    //       ),
    //       'list_of_evens': M.ntList(
    //         initialValue: [2, 4, 6, 8],
    //         validator: (n) => n.isEven,
    //         append: false,
    //       ),
    //     }),
    //   },
    //   modelValidator: (modelMap) => (modelMap['chosen_values']['date_begin'] as DateTime)
    //       .isBefore(modelMap['chosen_values']['date_end'] as DateTime),
    // );

    // final mod2 = model.update({
    //   'chosen_values': {'list_of_evens': (list) => list..insert(2, 60)}
    // });

    // print(mod2.toJsonDiff(model));
    // print(mod3);
    // print(mod2.mergeFrom(mod3));
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
