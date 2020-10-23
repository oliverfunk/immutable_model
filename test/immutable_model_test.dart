import 'dart:convert';

import 'package:test/test.dart';

import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';

enum TestEnum { en1, en2, en3 }

abstract class SomeState {
  const SomeState();
}

class SomeAState extends SomeState {
  const SomeAState();
}

class SomeBState extends SomeState {
  const SomeBState();
}

// todo: invalid init's
// todo: updates/dserialiastions with null
// todo: updates with improper types
// todo: updates with models of same value

// fix: enum value are dyanmic

void main() {
  test("Init test", () {
    print("TESTS STARTING");
  });
  group("ModelType tests:", () {
    // model primitives
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
        expect(updated.value, isNot(equals(mBool.value)));
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
        expect(updated.value, isNot(equals(mInt.value)));
      });
      test("Checking object value equality", () {
        expect(mInt, equals(ModelInt(initial: 1)));
        expect(updated, equals(ModelInt(initial: 9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mInt)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
            true,
            identical(
              mInt,
              inv,
            ));
        // invalid update returns the same model
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
        expect(updated.value, isNot(equals(mDbl.value)));
      });
      test("Checking object value equality", () {
        expect(mDbl, equals(ModelDouble(initial: 0.1)));
        expect(updated, equals(ModelDouble(initial: 0.9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDbl)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
            true,
            identical(
              mDbl,
              inv,
            ));
        // invalid update returns the same model
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
        expect(updated.value, isNot(equals(mStr.value)));
      });
      test("Checking object value equality", () {
        expect(mStr, equals(ModelString(initial: "Hello")));
        expect(updated, equals(ModelString(initial: "Baz")));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mStr)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
            true,
            identical(
              mStr,
              inv,
            ));
        // invalid update returns the same model
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
        expect(updated.value, isNot(equals(mDt.value)));
      });
      test("Checking object value equality", () {
        expect(mDt, equals(ModelDateTime(initial: DateTime(2020))));
        expect(updated, equals(ModelDateTime(initial: DateTime(2022))));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDt)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
            true,
            identical(
              mDt,
              inv,
            ));
        // invalid update returns the same model
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
    // model value types
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
    // model lists
    group("ModelBoolList:", () {
      final mBoolL = M.blList(
        initial: [true, false],
      );
      // update the model with another model holding the same value
      final same =
          mBoolL.nextFromModel(mBoolL.next([true]).next([true, false]));
      // update the model a couple of times with valid values
      final updated =
          mBoolL.next([true]).next([false, false]).next([false, true]);
      // update the updated instance with the same value
      final updatedSame = updated.next([false, true]);
      // updated the model with equivalent updates
      final updatedEqu =
          mBoolL.next([true]).next([false, false]).next([false, true]);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended = updated.append([true, true, false]);
      final replaced = updated.replaceAt(1, (_) => false);
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(mBoolL.value, equals([true, false]));
        expect(updated.value, equals([false, true]));
        expect(updated.value, isNot(equals(mBoolL.value)));
      });
      test("Checking object value equality", () {
        expect(mBoolL, equals(ModelBoolList(initial: [true, false])));
        expect(updated, equals(ModelBoolList(initial: [false, true])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mBoolL)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mBoolL,
            same,
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
            mBoolL,
          ),
          true,
        );
        // shares a history with itself
        expect(
          updated.hasEqualityOfHistory(
            updated,
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
            ModelBoolList(initial: [false, true]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([false, true]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mBoolL.nextFromSerialized(serialized), equals(updated));
        expect(mBoolL, equals(mBoolL.nextFromSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.list;
        vl[1] = false;
        expect(vl, equals([false, false]));
        expect(updated.value, equals([false, true]));
      });
      test("Checking list append", () {
        expect(appended,
            equals(ModelBoolList(initial: [false, true, true, true, false])));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelBoolList(initial: [false, false])));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelBoolList(initial: [false])));
      });
    });
    group("ModelIntList:", () {
      final mIntL = M.ntList(
        initial: [1, 2],
        itemValidator: (n) => n <= 10,
      );
      // update the model with another model holding the same value
      final same = mIntL.nextFromModel(mIntL.next([1]).next([1, 2]));
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
        expect(updated.value, isNot(equals(mIntL.value)));
      });
      test("Checking object value equality", () {
        expect(mIntL, equals(ModelIntList(initial: [1, 2])));
        expect(updated, equals(ModelIntList(initial: [5, 6])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mIntL)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mIntL,
            same,
          ),
          true,
        );
        // invalid update returns the same model
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
        // invalid update returns the same model
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
        final vl = updated.list;
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
    group("ModelDoubleList:", () {
      final mDblL = M.dblList(
        initial: [0.1, 0.2],
        itemValidator: (n) => n >= 0.1,
      );
      // update the model with another model holding the same value
      final same = mDblL.nextFromModel(mDblL.next([0.1]).next([0.1, 0.2]));
      // update the model with an invalid value
      final inv = mDblL.next([-0.9, 12]);
      // update the model a couple of times with valid values
      final updated = mDblL.next([0.9]).next([0.1, 0.2]).next([0.5, 0.6]);
      // update the updated instance with the same value
      final updatedSame = updated.next([0.5, 0.6]);
      // update the updated instance with an invalid value
      final updatedInv = updated.next([0.9, 0.012]);
      // updated the model with equivalent updates
      final updatedEqu = mDblL.next([0.9]).next([0.1, 0.2]).next([0.5, 0.6]);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended = updated.append([0.1, 0.2, 0.3]);
      final appendedInv = updated.append([0.1, -0.2, 33]);
      final replaced = updated.replaceAt(1, (_) => 4);
      final replacedInv = updated.replaceAt(1, (_) => -12);
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(mDblL.value, equals([0.1, 0.2]));
        expect(updated.value, equals([0.5, 0.6]));
        expect(updated.value, isNot(equals(mDblL.value)));
      });
      test("Checking object value equality", () {
        expect(mDblL, equals(ModelDoubleList(initial: [0.1, 0.2])));
        expect(updated, equals(ModelDoubleList(initial: [0.5, 0.6])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mDblL)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mDblL,
            same,
          ),
          true,
        );
        // invalid update returns the same model
        expect(
          identical(
            mDblL,
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
        // invalid update returns the same model
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
            mDblL,
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
            ModelDoubleList(initial: [0.5, 0.6]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([0.5, 0.6]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mDblL.nextFromSerialized(serialized), equals(updated));
        expect(mDblL, equals(mDblL.nextFromSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.list;
        vl[1] = -12;
        expect(vl, equals([0.5, -12]));
        expect(updated.value, equals([0.5, 0.6]));
      });
      test("Checking list append", () {
        expect(appended,
            equals(ModelDoubleList(initial: [0.5, 0.6, 0.1, 0.2, 0.3])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelDoubleList(initial: [0.5, 4])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelDoubleList(initial: [0.5])));
      });
    });
    group("ModelStringList:", () {
      final mStrL = M.strList(
        initial: ['Hello', 'World'],
        itemValidator: (s) => s[0] == s[0].toUpperCase(),
      );
      // update the model with another model holding the same value
      final same =
          mStrL.nextFromModel(mStrL.next(['Foo']).next(['Hello', 'World']));
      // update the model with an invalid value
      final inv = mStrL.next(['Hello', 'world']);
      // update the model a couple of times with valid values
      final updated =
          mStrL.next(['Baz']).next(['Foo', 'Baz']).next(['Foo', 'Bar']);
      // update the updated instance with the same value
      final updatedSame = updated.next(['Foo', 'Bar']);
      // update the updated instance with an invalid value
      final updatedInv = updated.next(['baz']);
      // updated the model with equivalent updates
      final updatedEqu =
          mStrL.next(['Baz']).next(['Foo', 'Baz']).next(['Foo', 'Bar']);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended = updated.append(['A', 'B', 'C']);
      final appendedInv = updated.append(['aA', 'Bb']);
      final replaced = updated.replaceAt(1, (_) => 'Baz');
      final replacedInv = updated.replaceAt(1, (_) => 'baz');
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(mStrL.value, equals(['Hello', 'World']));
        expect(updated.value, equals(['Foo', 'Bar']));
        expect(updated.value, isNot(equals(mStrL.value)));
      });
      test("Checking object value equality", () {
        expect(mStrL, equals(ModelStringList(initial: ['Hello', 'World'])));
        expect(updated, equals(ModelStringList(initial: ['Foo', 'Bar'])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mStrL)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mStrL,
            same,
          ),
          true,
        );
        // invalid update returns the same model
        expect(
          identical(
            mStrL,
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
        // invalid update returns the same model
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
            mStrL,
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
            ModelStringList(initial: ['Foo', 'Bar']),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(['Foo', 'Bar']));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mStrL.nextFromSerialized(serialized), equals(updated));
        expect(mStrL, equals(mStrL.nextFromSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.list;
        vl[1] = 'new';
        expect(vl, equals(['Foo', 'new']));
        expect(updated.value, equals(['Foo', 'Bar']));
      });
      test("Checking list append", () {
        expect(appended,
            equals(ModelStringList(initial: ['Foo', 'Bar', 'A', 'B', 'C'])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelStringList(initial: ['Foo', 'Baz'])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelStringList(initial: ['Foo'])));
      });
    });
    group("ModelDateTimeList:", () {
      final mDtL = M.dtList(
        initial: [DateTime(2020), DateTime(2021)],
        itemValidator: (listItem) => listItem.isAfter(DateTime(2000)),
      );
      // update the model with another model of equivalent value
      final equValue = mDtL.nextFromModel(
          mDtL.next([DateTime(2022)]).next([DateTime(2020), DateTime(2021)]));
      // update the model with an invalid value
      final inv = mDtL.next([DateTime(2020), DateTime(1995)]);
      // update the model a couple of times with valid values
      final updated = mDtL
          .next([DateTime(2040)]).next([DateTime(2042), DateTime(2040)]).next(
              [DateTime(2023), DateTime(2024)]);
      // update the updated instance with the same value
      final updatedSame = updated.next([DateTime(2023), DateTime(2024)]);
      // update the updated instance with an invalid value
      final updatedInv = updated.next([DateTime(1980)]);
      // updated the model with equivalent updates
      final updatedEqu = mDtL
          .next([DateTime(2040)]).next([DateTime(2042), DateTime(2040)]).next(
              [DateTime(2023), DateTime(2024)]);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended =
          updated.append([DateTime(2030), DateTime(2031), DateTime(2033)]);
      final appendedInv = updated.append([DateTime(1981), DateTime(1982)]);
      final replaced = updated.replaceAt(1, (_) => DateTime(2040));
      final replacedInv = updated.replaceAt(1, (_) => DateTime(1980));
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(mDtL.value, equals([DateTime(2020), DateTime(2021)]));
        expect(updated.value, equals([DateTime(2023), DateTime(2024)]));
        expect(updated.value, isNot(equals(mDtL.value)));
      });
      test("Checking object value equality", () {
        expect(
            mDtL,
            equals(
                ModelDateTimeList(initial: [DateTime(2020), DateTime(2021)])));
        expect(
            updated,
            equals(
                ModelDateTimeList(initial: [DateTime(2023), DateTime(2024)])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mDtL)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mDtL,
            equValue,
          ),
          true,
        );
        // invalid update returns the same model
        expect(
          identical(
            mDtL,
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
        // invalid update returns the same model
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
            mDtL,
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
            ModelDateTimeList(initial: [DateTime(2023), DateTime(2024)]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(
            serialized,
            equals([
              DateTime(2023).toIso8601String(),
              DateTime(2024).toIso8601String()
            ]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mDtL.nextFromSerialized(serialized), equals(updated));
        expect(mDtL.nextFromSerialized("wrong"), equals(mDtL));
      });
      test("Checking list internal mutation", () {
        final vl = updated.list;
        vl[1] = DateTime(1995);
        expect(vl, equals([DateTime(2023), DateTime(1995)]));
        expect(updated.value, equals([DateTime(2023), DateTime(2024)]));
      });
      test("Checking list append", () {
        expect(
            appended,
            equals(ModelDateTimeList(initial: [
              DateTime(2023),
              DateTime(2024),
              DateTime(2030),
              DateTime(2031),
              DateTime(2033)
            ])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(
          replaced,
          equals(ModelDateTimeList(initial: [DateTime(2023), DateTime(2040)])),
        );
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelDateTimeList(initial: [DateTime(2023)])));
      });
    });
    // model enum
    group("ModelEnum:", () {
      final mEnm = M.enm(TestEnum.values, TestEnum.en1);
      // update the model with another model of equivalent value
      final equValue =
          mEnm.nextFromModel(mEnm.next(TestEnum.en2).next(TestEnum.en1));
      // update the model a couple of times with valid values
      final updated =
          mEnm.next(TestEnum.en3).next(TestEnum.en2).next(TestEnum.en3);
      // update the updated instance with the same value
      final updatedSame = updated.next(TestEnum.en3);
      // updated the model with equivalent updates
      final updatedEqu =
          mEnm.next(TestEnum.en3).next(TestEnum.en2).next(TestEnum.en3);
      // serialize the model
      final serialized = updated.asSerializable();

      final updatedFromString = mEnm.nextFromString('en2');

      test("Checking value access", () {
        expect(mEnm.value, equals(TestEnum.en1));
        expect(updated.value, equals(TestEnum.en3));
        expect(updated.value, isNot(equals(mEnm.value)));
      });
      test("Checking object value equality", () {
        expect(
            mEnm,
            equals(
              ModelEnum<TestEnum>(TestEnum.values, TestEnum.en1),
            ));
        expect(
            updated,
            equals(
              ModelEnum<TestEnum>(TestEnum.values, TestEnum.en3),
            ));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mEnm)));
      });
      test("Checking new instance generation", () {
        // updating with a model that holds the same value
        expect(
          identical(
            mEnm,
            equValue,
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
            mEnm,
          ),
          true,
        );
        // shares a history with itself
        expect(
          updated.hasEqualityOfHistory(
            updated,
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
            ModelEnum<TestEnum>(TestEnum.values, TestEnum.en3),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals("en3"));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mEnm.nextFromSerialized(serialized), equals(updated));
        expect(mEnm.nextFromSerialized("wrong"), equals(mEnm));
      });
      test("Checking enum nextFromString", () {
        expect(updatedFromString.value, equals(TestEnum.en2));
      });
      test("Checking enum lists", () {
        expect(mEnm.enums, equals(TestEnum.values));
        expect(mEnm.enumStrings, equals(['en1', 'en2', 'en3']));
      });
    });
    // group("Model errors:", () {
    // invalid model dyanmic updates
    //   // todo: invalid enum invputs
    // invalid enum from string
    // });
  });
  group("ImmutableModel tests:", () {
    final model = ImmutableModel<SomeState>(
      {
        "prim_bool": M.bl(initial: false),
        "prim_int": M.nt(initial: 1, validator: (n) => n <= 10),
        "prim_double": M.dbl(initial: 0.1, validator: (n) => n >= 0.1),
        "prim_str": M.str(),
        "list_bool": M.blList(initial: [true, false]),
        "list_int": M.ntList(initial: [1, 2], itemValidator: (n) => n <= 10),
        "list_double": M.dblList(initial: [0.1, 0.2]),
        "list_str": M.strList(itemValidator: (s) => s[0] == s[0].toUpperCase()),
        "list_date_time": M.dtList(initial: [DateTime(2020), DateTime(2020)]),
        "enum": M.enm(TestEnum.values, TestEnum.en1),
        "inner": M.inner(
          {
            "prim_int": M.nt(initial: 1, validator: (n) => n <= 10),
            "prim_double": M.dbl(initial: 0.1, validator: (n) => n >= 0.1),
            "prim_str": M.str(),
          },
          strictUpdates: true,
        ),
      },
      modelValidator: (modelMap) =>
          modelMap['prim_int'].value > modelMap['prim_double'].value,
      initialState: const SomeAState(),
    );
    // simple model updates
    final updated = model.update({
      "prim_int": 5,
      "prim_double": (d) => d + 0.1,
      "prim_str": "Hello",
      "list_int": [3, 4],
      "enum": TestEnum.en2,
      "inner": {
        "prim_int": 5,
        "prim_double": (d) => d + 0.1,
        "prim_str": "Hello"
      }
    });
    // some invalid updates
    final updatedWithInv = updated.update({
      "prim_int": 9,
      "prim_double": (d) => d - 1.1,
      "list_int": [9, 12],
      "list_double": [0.4, 0.5]
    });
    // update the model with invalid values at the map level
    // i.e. between prim_int and prim_double
    final updatedWithInvBtwFields = updated.update({
      "prim_double": 6.1,
    });
    // attempt to update the inner without all fields
    final updatedWithStrictNotAllFields = updated.update({
      "inner": {
        "prim_int": 5,
        "prim_str": "Hello",
      },
    });
    // attempt to update the inner with some invalid fields
    final updatedWithStrictInv = updated.update({
      "inner": {
        "prim_int": 5,
        "prim_double": (d) => d - 1.1,
        "prim_str": "Hello"
      },
    });

    test("Checking update", () {
      expect(
        updated["prim_bool"],
        equals(false),
      );
      expect(
        updated["prim_int"],
        equals(5),
      );
      expect(
        updated["prim_double"],
        equals(0.2),
      );
      expect(
        updated["prim_str"],
        equals("Hello"),
      );
      expect(
        updated["list_int"],
        equals([3, 4]),
      );
      expect(
        updated["enum"],
        equals(TestEnum.en2),
      );
      expect(
        updated["inner"]['prim_int'],
        equals(5),
      );
      expect(
        updated["inner"]['prim_double'],
        equals(0.2),
      );
      expect(
        updated["inner"]['prim_str'],
        equals("Hello"),
      );
    });
    test("Checking update with inv. values", () {
      expect(
        updatedWithInv['prim_int'],
        equals(9),
      );
      expect(
        updatedWithInv['prim_double'],
        equals(0.2),
      );
      expect(
        updatedWithInv['list_int'],
        equals([3, 4]),
      );
      expect(
        updatedWithInv['list_double'],
        equals([0.4, 0.5]),
      );
    });
    test("Checking update with inv. values between fields", () {
      expect(
        updatedWithInvBtwFields,
        equals(updated),
      );
    });
    test("Checking strict updates", () {
      expect(
        updatedWithStrictNotAllFields,
        equals(updated),
      );
      expect(
        updatedWithStrictInv,
        equals(updated),
      );
    });
    test("Checking updateIfIn", () {
      expect(
        updated.updateIfIn(
          {
            "prim_int": 3,
          },
          const SomeAState(),
        ),
        equals(updated.update(
          {
            "prim_int": 3,
          },
        )),
      );
      expect(
        () => updated.updateIfIn(
          {
            "prim_int": 3,
          },
          const SomeBState(),
        ),
        throwsA(TypeMatcher<ModelStateError>()),
      );
    });
    test(
      "Checking updateWithSelector",
      () {
        expect(
          updated.updateWithSelector(ModelSelector("list_int"), [6, 7]),
          equals(updated.update({
            "list_int": [6, 7]
          })),
        );
      },
    );
    test(
      "Checking updateWithSelectorIfIn",
      () {
        expect(
          updated.updateWithSelectorIfIn(
            ModelSelector("list_int"),
            [6, 7],
            const SomeAState(),
          ),
          updated.update({
            "list_int": [6, 7]
          }),
        );
        expect(
          () => updated.updateWithSelectorIfIn(
            ModelSelector("list_int"),
            [6, 7],
            const SomeBState(),
          ),
          throwsA(TypeMatcher<ModelStateError>()),
        );
      },
    );
    test("Checking mergeFrom", () {
      final toMerge = model.update({
        "list_int": [8, 9],
      });
      final merged = updated.mergeFrom(toMerge);
      expect(
        merged["prim_bool"],
        equals(false),
      );
      expect(
        merged["prim_int"],
        equals(5),
      );
      expect(
        merged["prim_double"],
        equals(0.2),
      );
      expect(
        merged["list_int"],
        equals([8, 9]),
      );
    });
    test("Checking resetFields", () {
      final reset =
          updated.resetFields(['prim_str', 'list_int', 'inner', 'enum']);
      expect(
        reset['prim_int'],
        equals(5),
      );
      expect(
        reset["prim_str"],
        equals(null),
      );
      expect(
        reset["list_int"],
        equals([1, 2]),
      );
      expect(
        reset["enum"],
        equals(TestEnum.en1),
      );
      expect(
        reset["inner"],
        equals(model["inner"]),
      );
    });
    test("Checking resetAll", () {
      expect(updated.resetAll(), equals(model));
    });
    test("Checking transitionTo", () {
      expect(
        updated.transitionTo(const SomeBState()).currentState,
        equals(const SomeBState()),
      );
    });
    test("Checking resetAndTransitionTo", () {
      final reset = updated.resetAndTransitionTo(const SomeBState());
      expect(
        reset.inner,
        equals(model.inner),
      );
      expect(
        reset.currentState,
        equals(const SomeBState()),
      );
    });
    test("Checking transitionToAndUpdate and updateTo", () {
      final toUpdate = updated.transitionToAndUpdate(
        const SomeBState(),
        {
          "prim_str": "Goodbye",
        },
      );
      expect(updated.updateTo(toUpdate), equals(toUpdate));
    });
    test("Checking toJSON/fromJSON", () {
      expect(
        model.fromJson(jsonDecode(jsonEncode(model.toJson()))),
        equals(model),
      );
    });
  });
}
