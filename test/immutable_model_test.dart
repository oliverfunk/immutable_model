import 'package:test/test.dart';

import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';

enum TestEnum { en1, en2, en3 }

void main() {
  group("ImmutableModel and ModelType tests:", () {
    final mBool = M.bl(initial: false);
    final mInt = M.nt(initial: 1, validator: (n) => n <= 10);
    final mDbl = M.dbl(initial: 0.1);
    final mStr = M.str();
    final mTxt = M.txt(initial: "Hello");
    final mDt = M.dt(initial: DateTime(2020));

    final mBoolL = M.blList();
    final mIntL = M.ntList(
        initial: [1, 2, 3, 4], itemValidator: (n) => n <= 10, append: false);
    final mDblL = M.dblList();
    final mStrL = M.strList(initial: ['hello', 'world']);
    final mDtL = M.dtList(initial: [DateTime(2020), DateTime(2021)]);

    final mEnm = M.enm(TestEnum.values, TestEnum.en1);

    final mEmil = M.email(defaultEmail: "example@gmail.com");
    final mPass = M.password();

    final model = ImmutableModel({
      "bool": mBool,
      "int": mInt,
      "double": mDbl,
      "string": mStr,
      "text": mTxt,
      "date_time": mDt,
    });

    group("ModelType tests:", () {
      test("object value equalities", () {
        // model primitives
        expect(mBool, equals(ModelBool(initial: false)));
        expect(mBool, isNot(equals(ModelBool(initial: true))));
        expect(mInt, equals(ModelInt(initial: 1)));
        expect(mDbl, equals(ModelDouble(initial: 0.1)));
        expect(mStr, equals(ModelString(initial: null)));
        expect(mTxt, equals(ModelString.text(initial: "Hello")));
        expect(mDt, equals(ModelDateTime(initial: DateTime(2020))));
        // model lists
        expect(mBoolL, equals(ModelBoolList()));
        expect(mIntL, equals(ModelIntList(initial: [1, 2, 3, 4])));
        expect(mIntL, isNot(equals(ModelIntList(initial: [1, 2, 3]))));
        expect(mDblL, equals(ModelDoubleList()));
        expect(mDblL, isNot(equals(ModelDoubleList(initial: [0.1]))));
        expect(mStrL, equals(ModelStringList(initial: ["hello", "world"])));
        expect(
            mDtL,
            equals(
              ModelDateTimeList(initial: [DateTime(2020), DateTime(2021)]),
            ));
        // model enum
        expect(mEnm, equals(ModelEnum(TestEnum.values, TestEnum.en1)));
        expect(mEnm, isNot(equals(ModelEnum(TestEnum.values, TestEnum.en2))));
        // value types
        expect(mEmil, equals(ModelEmail('example@gmail.com')));
        expect(mPass, equals(ModelPassword(null)));
        // ImmutableModel/model inner
        expect(
            model,
            equals(ImmutableModel({
              "bool": mBool,
              "int": mInt,
              "double": mDbl,
              "string": mStr,
              "text": mTxt,
              "date_time": mDt,
            })));
      });

      test("accessing model values and attempting to mutate them", () {
        final l = mDtL.value;
        l[1] = DateTime(2022); // mutate the value from the model
        expect(
            l,
            equals(
              [DateTime(2020), DateTime(2022)],
            ));
        expect(
            mDtL.value,
            equals(
              [DateTime(2020), DateTime(2021)],
            )); // checks if the internal list was mutated
      });

      test("updating models", () {
        expect(mInt.next(9), equals(ModelInt(initial: 9)));
        expect(mInt.next(9).value, equals(9));
        expect(mInt.next(9), isNot(equals(mInt)));
        expect(mInt.next(9), equals(mInt.next(9)));
        expect(
            false,
            identical(
              mInt.next(9),
              mInt.next(9),
            )); // calling next creates a new instance, even if it has the same value as another
        expect(
            true,
            identical(
              mInt.next(11),
              mInt,
            )); // invalid update returns the same model (for model types)

        expect(mTxt.next(''), mTxt); // text should reject empty strings
      });
    });

    group("model definition with M", () {});

    group("model updates and resets", () {});

    group("model JSON handling", () {});
  });
}
