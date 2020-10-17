import 'package:test/test.dart';

import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';

enum TestEnum { en1, en2, en3 }

// todo: invalid init's
// todo: updates/dserialiastions with null
// todo: updates this idetintelcal mdoels
// todo: construct null validators

void main() {
  group("ImmutableModel and ModelType tests:", () {
    group("ModelBool:", () {
      final mBool = M.bl(initial: false);
      // update the model a couple of times with valid values
      final updated = mBool.next(false).next(true);
      // update the updated instance with the same value
      final updatedSame = updated.next(true);
      // updated the model with equivalent updates
      final updatedEqu = mBool.next(false).next(true);
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mBool.value, equals(false));
        expect(updated.value, equals(true));
      });
      test("Checking object value equality", () {
        expect(mBool, equals(ModelBool(initial: false)));
        expect(updated, equals(ModelBool(initial: true)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mBool)));
      });
      test("Checking new instance generation", () {
        // updating with the same value should return the same instance
        expect(
            true,
            identical(
              updated,
              updatedSame,
            ));
        // equivalent updates return a different instance
        expect(
            false,
            identical(
              updated,
              updatedEqu,
            ));
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              mBool,
            ));
        // shares a history with itself
        expect(
            true,
            updated.hasEqualityOfHistory(
              updated,
            ));
        // shares a history with an indirect ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedEqu,
            ));
        // does not share a history with a new instance (model types only)
        expect(
            false,
            updated.hasEqualityOfHistory(
              ModelBool(initial: true),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals(true));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mBool.nextFromSerialized(serialized), equals(updated));
      });
    });
    group("ModelInt:", () {
      final mInt = M.nt(initial: 1, validator: (n) => n <= 10);
      // update the model with an invalid value
      final inv = mInt.next(11);
      // update the model a couple of times with valid values
      final updated = mInt.next(2).next(5).next(9);
      // update the updated instance with an invalid value
      final updatedInv = updated.next(11);
      // update the updated instance with the same value
      final updatedSame = updated.next(9);
      // updated the model with equivalent updates
      final updatedEqu = mInt.next(2).next(5).next(9);
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mInt.value, equals(1));
        expect(updated.value, equals(9));
      });
      test("Checking object value equality", () {
        expect(mInt, equals(ModelInt(initial: 1)));
        expect(updated, equals(ModelInt(initial: 9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mInt)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              mInt,
              inv,
            ));
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              updated,
              updatedInv,
            ));
        // updating with the same value should return the same instance
        expect(
            true,
            identical(
              updated,
              updatedSame,
            ));
        // equivalent updates return a different instance
        expect(
            false,
            identical(
              updated,
              updatedEqu,
            ));
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              mInt,
            ));
        // shares a history with itself
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedInv,
            ));
        // shares a history with an indirect ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedEqu,
            ));
        // does not share a history with a new instance (model types only)
        expect(
            false,
            updated.hasEqualityOfHistory(
              ModelInt(initial: 9),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals(9));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(updated, equals(mInt.nextFromSerialized(serialized)));
        expect(mInt, equals(mInt.nextFromSerialized("wrong")));
      });
    });
    group("ModelDouble:", () {
      final mDbl = M.dbl(initial: 0.1, validator: (n) => n >= 0.1);
      // update the model with an invalid value
      final inv = mDbl.next(-0.1);
      // update the model a couple of times with valid values
      final updated = mDbl.next(0.2).next(0.5).next(0.9);
      // update the updated instance with the same value
      final updatedSame = updated.next(0.9);
      // update the updated instance with an invalid value
      final updatedInv = updated.next(-0.1);
      // updated the model with equivalent updates
      final updatedEqu = mDbl.next(0.2).next(0.5).next(0.9);
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mDbl.value, equals(0.1));
        expect(updated.value, equals(0.9));
      });
      test("Checking object value equality", () {
        expect(mDbl, equals(ModelDouble(initial: 0.1)));
        expect(updated, equals(ModelDouble(initial: 0.9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDbl)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              mDbl,
              inv,
            ));
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              updated,
              updatedInv,
            ));
        // updating with the same value should return the same instance
        expect(
            true,
            identical(
              updated,
              updatedSame,
            ));
        // equivalent updates return a different instance
        expect(
            false,
            identical(
              updated,
              updatedEqu,
            ));
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              mDbl,
            ));
        // shares a history with itself
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedInv,
            ));
        // shares a history with an indirect ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedEqu,
            ));
        // does not share a history with a new instance (model types only)
        expect(
            false,
            updated.hasEqualityOfHistory(
              ModelDouble(initial: 9),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals(0.9));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(updated, equals(mDbl.nextFromSerialized(serialized)));
      });
    });
    group("ModelString:", () {
      final mStr = M.txt(initial: "Hello");
      // update the model with an invalid value
      final inv = mStr.next('');
      // update the model a couple of times with valid values
      final updated = mStr.next("Foo").next("Bar").next("Baz");
      // update the updated instance with the same value
      final updatedSame = updated.next("Baz");
      // update the updated instance with an invalid value
      final updatedInv = updated.next('');
      // updated the model with equivalent updates
      final updatedEqu = mStr.next("Foo").next("Bar").next("Baz");
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mStr.value, equals('Hello'));
        expect(updated.value, equals('Baz'));
      });
      test("Checking object value equality", () {
        expect(mStr, equals(ModelString(initial: "Hello")));
        expect(updated, equals(ModelString(initial: "Baz")));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mStr)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              mStr,
              inv,
            ));
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              updated,
              updatedInv,
            ));
        // updating with the same value should return the same instance
        expect(
            true,
            identical(
              updated,
              updatedSame,
            ));
        // equivalent updates return a different instance
        expect(
            false,
            identical(
              updated,
              updatedEqu,
            ));
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              mStr,
            ));
        // shares a history with itself
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedInv,
            ));
        // shares a history with an indirect ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedEqu,
            ));
        // does not share a history with a new instance (model types only)
        expect(
            false,
            updated.hasEqualityOfHistory(
              ModelString(initial: "Baz"),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals("Baz"));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(updated, equals(mStr.nextFromSerialized(serialized)));
      });
    });
    group("ModelDateTime:", () {
      final mDt =
          M.dt(initial: DateTime(2020), validator: (dt) => dt.year >= 2020);
      // update the model with an invalid value
      final inv = mDt.next(DateTime(2000));
      // update the model a couple of times with valid values
      final updated =
          mDt.next(DateTime(2021)).next(DateTime(2025)).next(DateTime(2022));
      // update the updated instance with the same value
      final updatedSame = updated.next(DateTime(2022));
      // update the updated instance with an invalid value
      final updatedInv = updated.next(DateTime(2000));
      // updated the model with equivalent updates
      final updatedEqu =
          mDt.next(DateTime(2021)).next(DateTime(2025)).next(DateTime(2022));
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mDt.value, equals(DateTime(2020)));
        expect(updated.value, equals(DateTime(2022)));
      });
      test("Checking object value equality", () {
        expect(mDt, equals(ModelDateTime(initial: DateTime(2020))));
        expect(updated, equals(ModelDateTime(initial: DateTime(2022))));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDt)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              mDt,
              inv,
            ));
        // invalid update returns the same model (for model types)
        expect(
            true,
            identical(
              updated,
              updatedInv,
            ));
        // updating with the same value should return the same instance
        expect(
            true,
            identical(
              updated,
              updatedSame,
            ));
        // equivalent updates return a different instance
        expect(
            false,
            identical(
              updated,
              updatedEqu,
            ));
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              mDt,
            ));
        // shares a history with itself
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedInv,
            ));
        // shares a history with an indirect ancestor
        expect(
            true,
            updated.hasEqualityOfHistory(
              updatedEqu,
            ));
        // does not share a history with a new instance (model types only)
        expect(
            false,
            updated.hasEqualityOfHistory(
              ModelDateTime(initial: DateTime(2022)),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals(DateTime(2022).toIso8601String()));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(updated, equals(mDt.nextFromSerialized(serialized)));
      });
    });
    // model lists
    // group(
    //   "ModelBoolList:",
    //   () {
    //     final mBoolL = M.blList();
    //     expect(mBoolL, equals(ModelBoolList()));
    //   },
    // );
    group("ModelIntList:", () {
      // Using append = false for these tests
      final mIntL = M.ntList(
        initial: [1, 2],
        itemValidator: (n) => n <= 10,
      );
      // update the model with an invalid value
      final inv = mIntL.next([9, 12]);
      // update the model a couple of times with valid values
      final updated = mIntL.next([9]).next([1, 2]).next([5, 6]);
      // update the updated instance with the same value
      final updatedSame = updated.next([5, 6]);
      // update the updated instance with an invalid value
      final updatedInv = updated.next([9, 12]);
      // updated the model with equivalent updates
      final updatedEqu = mIntL.next([9]).next([1, 2]).next([5, 6]);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended = updated.append([1, 2, 3]);
      final appendedInv = updated.append([1, 2, 33]);
      final replaced = updated.replaceAt(1, (_) => 4);
      final replacedInv = updated.replaceAt(1, (_) => 12);
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(mIntL.value, equals([1, 2]));
        expect(updated.value, equals([5, 6]));
      });
      test("Checking object value equality", () {
        expect(mIntL, equals(ModelIntList(initial: [1, 2])));
        expect(updated, equals(ModelIntList(initial: [5, 6])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mIntL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model (for model types)
        expect(
          identical(
            mIntL,
            inv,
          ),
          true,
        );
        // updating with the same value should return the same instance
        expect(
          identical(
            updated,
            updatedSame,
          ),
          true,
        );
        // invalid update returns the same model (for model types)
        expect(
          identical(
            updated,
            updatedInv,
          ),
          true,
        );
        // equivalent updates return a different instance
        expect(
          identical(
            updated,
            updatedEqu,
          ),
          false,
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mIntL,
          ),
          true,
        );
        // shares a history with itself
        expect(
          updated.hasEqualityOfHistory(
            updatedInv,
          ),
          true,
        );
        // shares a history with an indirect ancestor
        expect(
          updated.hasEqualityOfHistory(
            updatedEqu,
          ),
          true,
        );
        // does not share a history with a new instance (model types only)
        expect(
          updated.hasEqualityOfHistory(
            ModelIntList(initial: [5, 6]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([5, 6]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mIntL.nextFromSerialized(serialized), equals(updated));
        expect(mIntL, equals(mIntL.nextFromSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.value;
        vl[1] = 12;
        expect(vl, equals([5, 12]));
        expect(updated.value, equals([5, 6]));
      });
      test("Checking list append", () {
        expect(appended, equals(ModelIntList(initial: [5, 6, 1, 2, 3])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelIntList(initial: [5, 4])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelIntList(initial: [5])));
      });
    });
    // group(
    //   "ModelDoubleList:",
    //   () {
    //     final mDblL = M.dblList();
    //     expect(mDblL, equals(ModelDoubleList()));
    //     expect(mDblL, isNot(equals(ModelDoubleList(initial: [0.1]))));
    //   },
    // );
    // group(
    //   "ModelStringList:",
    //   () {
    //     final mStrL = M.strList(initial: ['hello', 'world']);
    //     expect(mStrL, equals(ModelStringList(initial: ["hello", "world"])));
    //   },
    // );
    // group("ModelDateTimeList:", () {
    //   final mDtL = M.dtList(initial: [DateTime(2020), DateTime(2021)]);
    //   expect(
    //       mDtL,
    //       equals(
    //         ModelDateTimeList(initial: [DateTime(2020), DateTime(2021)]),
    //       ));
    //   final l = mDtL.value;
    //   l[1] = DateTime(2022); // mutate the value from the model
    //   expect(
    //       l,
    //       equals(
    //         [DateTime(2020), DateTime(2022)],
    //       ));
    //   expect(
    //       mDtL.value,
    //       equals(
    //         [DateTime(2020), DateTime(2021)],
    //       )); // checks if the internal list was mutated
    // });
    // group(
    //   "ModelEnum:",
    //   () {
    //     final mEnm = M.enm(TestEnum.values, TestEnum.en1);
    //     expect(mEnm, equals(ModelEnum(TestEnum.values, TestEnum.en1)));
    //     expect(mEnm, isNot(equals(ModelEnum(TestEnum.values, TestEnum.en2))));
    //   },
    // );
    // // model inner
    // group(
    //   "ModelInner:",
    //   () {},
    // );

    // group(
    //   "ModelEmail:",
    //   () {
    //     final mEmil = M.email(defaultEmail: "example@gmail.com");
    //   },
    // );
    // group(
    //   "ModelPassword:",
    //   () {
    //     final mPass = M.password();
    //   },
    // );

    // group("ImmutableModel", () {
    //   final model = ImmutableModel({
    //     "bool": M.bl(initial: false),
    //     "int": M.nt(initial: 1, validator: (n) => n <= 10),
    //     "double": mDbl,
    //     "string": mStr,
    //     "text": mTxt,
    //     "date_time": mDt,
    //   });
    // });
  });
}
