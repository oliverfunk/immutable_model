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

void main() {
  test("Init", () {
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
        expect(mBool, equals(ModelBool(false)));
        expect(updated, equals(ModelBool(true)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mBool)));
      });
      test("Checking new instance generation", () {
        // updating with a model should return that model instance
        expect(
          mBool.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
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
              ModelBool(true),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals(true));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mBool.nextWithSerialized(serialized), equals(updated));
        expect(mBool.nextWithSerialized("wrong"), equals(mBool));
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
        expect(mInt, equals(ModelInt(1)));
        expect(updated, equals(ModelInt(9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mInt)));
      });
      test("Checking new instance generation", () {
        // updating with null
        expect(
          mInt.next(null),
          same(mInt),
        );
        // invalid update returns the same model
        expect(
          inv,
          same(mInt),
        );
        // updating with a model should return that model instance
        expect(
          mInt.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mInt,
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
            ModelStringList(['Foo', 'Bar']),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(9));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mInt.nextWithSerialized(serialized), equals(updated));
        expect(mInt.nextWithSerialized("wrong"), equals(mInt));
        expect(mInt.nextWithSerialized(null), same(mInt));
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
        expect(mDbl, equals(ModelDouble(0.1)));
        expect(updated, equals(ModelDouble(0.9)));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDbl)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mDbl),
        );
        // updating with a model should return that model instance
        expect(
          mDbl.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mDbl,
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
            ModelStringList(['Foo', 'Bar']),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(0.9));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mDbl.nextWithSerialized(serialized), equals(updated));
        expect(mDbl.nextWithSerialized("wrong"), equals(mDbl));
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
        expect(mStr, equals(ModelString("Hello")));
        expect(updated, equals(ModelString("Baz")));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mStr)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mStr),
        );
        // updating with a model should return that model instance
        expect(
          mStr.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
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
              ModelString("Baz"),
            ));
      });
      test("Checking serialization", () {
        expect(serialized, equals("Baz"));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mStr.nextWithSerialized(serialized), equals(updated));
        expect(mStr.nextWithSerialized(7), equals(mStr));
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
        expect(mDt, equals(ModelDateTime(DateTime(2020))));
        expect(updated, equals(ModelDateTime(DateTime(2022))));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mDt)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mDt),
        );
        // updating with a model should return that model instance
        expect(
          mDt.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mDt,
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
            ModelStringList(['Foo', 'Bar']),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(DateTime(2022).toIso8601String()));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mDt.nextWithSerialized(serialized), equals(updated));
        expect(mDt.nextWithSerialized("wrong"), equals(mDt));
      });
    });
    // model value types
    group("ModelEmail:", () {
      final mEmail = M.email(defaultEmail: "ex@gmail.com");
      // update the model with an invalid value
      final inv = mEmail.next('notanemail');
      // update the model a couple of times with valid values
      final updated =
          mEmail.next('a@gmail.com').next('b@gmail.com').next('c@gmail.com');
      // update the updated instance with the same value
      final updatedSame = updated.next('c@gmail.com');
      // update the updated instance with an invalid value
      final updatedInv = updated.next('notanemail');
      // updated the model with equivalent updates
      final updatedEqu =
          mEmail.next('a@gmail.com').next('b@gmail.com').next('c@gmail.com');
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mEmail.value, equals("ex@gmail.com"));
        expect(updated.value, equals("c@gmail.com"));
        expect(updated.value, isNot(equals(mEmail.value)));
      });
      test("Checking object value equality", () {
        expect(mEmail, equals(ModelEmail("ex@gmail.com")));
        expect(updated, equals(ModelEmail("c@gmail.com")));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mEmail)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mEmail),
        );
        // updating with a model that shares an initial instance should return the model instance (value types only)
        expect(
          mEmail.nextFromModel(updated),
          same(updated),
        );
        // updating with a model that does not share an initial instance should return a new model instance (value types only)
        final newModel = ModelEmail('test@gmail.com');
        expect(
          mEmail.nextFromModel(newModel),
          isNot(same(newModel)),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mEmail,
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
        // DOES share a history with a new instance (value types only)
        expect(
          updated.hasEqualityOfHistory(
            ModelEmail("c@gmail.com"),
          ),
          true,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals('c@gmail.com'));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mEmail.nextWithSerialized(serialized), equals(updated));
        expect(mEmail, equals(mEmail.nextWithSerialized("notanemail")));
      });
    });
    group("ModelPassword:", () {
      final mPass = M.password();
      // update the model with an invalid value
      final inv = mPass.next('notvalid');
      // update the model a couple of times with valid values
      final updated =
          mPass.next('Validpass1').next('Validpass2').next('Validpass3');
      // update the updated instance with the same value
      final updatedSame = updated.next('Validpass3');
      // update the updated instance with an invalid value
      final updatedInv = updated.next('notvalid');
      // updated the model with equivalent updates
      final updatedEqu =
          mPass.next('Validpass1').next('Validpass2').next('Validpass3');
      // serialize the model
      final serialized = updated.asSerializable();

      test("Checking value access", () {
        expect(mPass.value, equals(null));
        expect(updated.value, equals("Validpass3"));
        expect(updated.value, isNot(equals(mPass.value)));
      });
      test("Checking object value equality", () {
        expect(mPass, equals(ModelPassword(null)));
        expect(updated, equals(ModelPassword("Validpass3")));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mPass)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mPass),
        );
        // updating with a model that shares an initial instance should return the model instance (value types only)
        expect(
          mPass.nextFromModel(updated),
          same(updated),
        );
        // updating with a model that does not share an initial instance should return a new model instance (value types only)
        final newModel = ModelPassword('Validpass5');
        expect(
          mPass.nextFromModel(newModel),
          isNot(same(newModel)),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mPass,
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
        // DOES share a history with a new instance (value types only)
        expect(
          updated.hasEqualityOfHistory(
            ModelPassword("Validpass3"),
          ),
          true,
        );
      });
      test("Checking serialization", () {
        expect(
            serialized,
            equals(
              '74e6759b0bb98164fcf3a9f31ac4086c830198c2604a97c8bb76d21c1d6e3e13',
            ));
      });
    });
    // model lists
    group("ModelBoolList:", () {
      final mBoolL = M.blList(
        initial: [true, false],
      );
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
        expect(mBoolL, equals(ModelBoolList([true, false])));
        expect(updated, equals(ModelBoolList([false, true])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mBoolL)));
      });
      test("Checking new instance generation", () {
        // updating with a model should return that model instance
        expect(
          mBoolL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
            ModelBoolList([false, true]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([false, true]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mBoolL.nextWithSerialized(serialized), equals(updated));
        expect(mBoolL, equals(mBoolL.nextWithSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = false;
        expect(vl, equals([false, false]));
        expect(updated.value, equals([false, true]));
      });
      test("Checking list append", () {
        expect(
            appended, equals(ModelBoolList([false, true, true, true, false])));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelBoolList([false, false])));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelBoolList([false])));
      });
    });
    group("ModelIntList:", () {
      final mIntL = M.ntList(initial: [1, 2], itemValidator: (n) => n <= 10);
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
      final sorted = updated.sort((a, b) => a < b ? 1 : -1);

      test("Checking value access", () {
        expect(mIntL.value, equals([1, 2]));
        expect(updated.value, equals([5, 6]));
        expect(updated.value, isNot(equals(mIntL.value)));
      });
      test("Checking object value equality", () {
        expect(mIntL, equals(ModelIntList([1, 2])));
        expect(updated, equals(ModelIntList([5, 6])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mIntL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mIntL),
        );
        // updating with a model should return that model instance
        expect(
          mIntL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
            ModelIntList([5, 6]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([5, 6]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mIntL.nextWithSerialized(serialized), equals(updated));
        expect(mIntL, equals(mIntL.nextWithSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = 12;
        expect(vl, equals([5, 12]));
        expect(updated.value, equals([5, 6]));
      });
      test("Checking list append", () {
        expect(appended, equals(ModelIntList([5, 6, 1, 2, 3])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelIntList([5, 4])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelIntList([5])));
      });
      test("Checking list sort", () {
        expect(
          sorted,
          equals(ModelIntList([6, 5])),
        );
        expect(
          sorted,
          isNot(equals(ModelIntList([5, 6]))),
        );
      });
    });
    group("ModelDoubleList:", () {
      final mDblL = M.dblList(
        initial: [0.1, 0.2],
        itemValidator: (n) => n >= 0.1,
      );
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
        expect(mDblL, equals(ModelDoubleList([0.1, 0.2])));
        expect(updated, equals(ModelDoubleList([0.5, 0.6])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mDblL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mDblL),
        );
        // updating with a model should return that model instance
        expect(
          mDblL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
            ModelDoubleList([0.5, 0.6]),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals([0.5, 0.6]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mDblL.nextWithSerialized(serialized), equals(updated));
        expect(mDblL, equals(mDblL.nextWithSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = -12;
        expect(vl, equals([0.5, -12]));
        expect(updated.value, equals([0.5, 0.6]));
      });
      test("Checking list append", () {
        expect(appended, equals(ModelDoubleList([0.5, 0.6, 0.1, 0.2, 0.3])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelDoubleList([0.5, 4])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelDoubleList([0.5])));
      });
    });
    group("ModelStringList:", () {
      final mStrL = M.strList(
        initial: ['Hello', 'World'],
        itemValidator: (s) => s[0] == s[0].toUpperCase(),
      );
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
        expect(mStrL, equals(ModelStringList(['Hello', 'World'])));
        expect(updated, equals(ModelStringList(['Foo', 'Bar'])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mStrL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mStrL),
        );
        // updating with a model should return that model instance
        expect(
          mStrL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
            ModelStringList(['Foo', 'Bar']),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(['Foo', 'Bar']));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mStrL.nextWithSerialized(serialized), equals(updated));
        expect(mStrL, equals(mStrL.nextWithSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = 'new';
        expect(vl, equals(['Foo', 'new']));
        expect(updated.value, equals(['Foo', 'Bar']));
      });
      test("Checking list append", () {
        expect(
            appended, equals(ModelStringList(['Foo', 'Bar', 'A', 'B', 'C'])));
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(replaced, equals(ModelStringList(['Foo', 'Baz'])));
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelStringList(['Foo'])));
      });
    });
    group("ModelDateTimeList:", () {
      final mDtL = M.dtList(
        initial: [DateTime(2020), DateTime(2021)],
        itemValidator: (listItem) => listItem.isAfter(DateTime(2000)),
      );
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
      final sorted = updated.sort((a, b) => a.isBefore(b) ? 1 : -1);

      test("Checking value access", () {
        expect(mDtL.value, equals([DateTime(2020), DateTime(2021)]));
        expect(updated.value, equals([DateTime(2023), DateTime(2024)]));
        expect(updated.value, isNot(equals(mDtL.value)));
      });
      test("Checking object value equality", () {
        expect(
            mDtL, equals(ModelDateTimeList([DateTime(2020), DateTime(2021)])));
        expect(updated,
            equals(ModelDateTimeList([DateTime(2023), DateTime(2024)])));
        expect(updated, equals(updatedEqu));
        expect(updated, isNot(equals(mDtL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mDtL),
        );
        // updating with a model should return that model instance
        expect(
          mDtL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // invalid update returns the same model
        expect(
          updatedInv,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
            ModelDateTimeList([DateTime(2023), DateTime(2024)]),
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
        expect(mDtL.nextWithSerialized(serialized), equals(updated));
        expect(mDtL.nextWithSerialized("wrong"), equals(mDtL));
        expect(mDtL.nextWithSerialized(["notadt"]), equals(mDtL));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = DateTime(1995);
        expect(vl, equals([DateTime(2023), DateTime(1995)]));
        expect(updated.value, equals([DateTime(2023), DateTime(2024)]));
      });
      test("Checking list append", () {
        expect(
            appended,
            equals(ModelDateTimeList([
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
          equals(ModelDateTimeList([DateTime(2023), DateTime(2040)])),
        );
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(removed, equals(ModelDateTimeList([DateTime(2023)])));
      });
      test("Checking list sort", () {
        expect(
          sorted,
          equals(ModelDateTimeList([DateTime(2024), DateTime(2023)])),
        );
        expect(
          sorted,
          isNot(equals(ModelDateTimeList([DateTime(2023), DateTime(2024)]))),
        );
      });
    });
    group("ModelInnerList:", () {
      final mInL = M.inList(
        innerModel: ModelInner({
          "outer_int": M.nt(initial: 1),
          "inner": M.inner(
            {
              "inner_int": M.nt(validator: (n) => n >= 10),
              "inner_dt": M.dt(initial: DateTime(2020)),
            },
            strictUpdates: true,
          ),
        }),
        initial: [
          {
            "inner": {
              "inner_int": 11,
              "inner_dt": DateTime(2021),
            }
          },
          {
            "outer_int": 2,
          },
        ],
      );
      final innerModel = mInL.inner;
      // update the model with an invalid value
      final inv = mInL.next([
        ModelInner({'defsnotvalid': M.nt(initial: 1)})
      ]);
      // update the model a couple of times with valid values
      final updated = mInL.next([
        innerModel.nextWithUpdates({
          "outer_int": 2,
        })
      ]).next([
        innerModel.nextWithUpdates({
          "outer_int": 5,
        }),
        innerModel.nextWithUpdates({
          "inner": {
            "inner_int": 110,
            "inner_dt": DateTime(2022),
          }
        }),
      ]);
      // update the updated instance with the same value
      final updatedSame = updated.next([
        innerModel.nextWithUpdates({
          "outer_int": 5,
        }),
        innerModel.nextWithUpdates({
          "inner": {
            "inner_int": 110,
            "inner_dt": DateTime(2022),
          }
        }),
      ]);
      // serialize the model
      final serialized = updated.asSerializable();

      final inner = updated.inner;
      final appended = updated.append([
        inner.nextWithUpdates({
          "outer_int": 7,
        })
      ]);
      final appendedInv = updated.append([
        ModelInner({'defsnotvalid': M.nt(initial: 1)})
      ]);
      final replaced =
          updated.replaceAt(0, (i) => i.nextWithUpdates({"outer_int": 55}));
      final replacedInv = updated.replaceAt(
          1, (_) => ModelInner({'defsnotvalid': M.nt(initial: 1)}));
      final removed = updated.removeAt(1);
      final sorted = updated.sort(
          (a, b) => (a['outer_int'] as int) > (b['outer_int'] as int) ? 1 : -1);

      test("Checking value access", () {
        expect(
          mInL.value,
          equals([
            ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(initial: 11),
                  "inner_dt": M.dt(initial: DateTime(2021)),
                },
              ),
            }),
            ModelInner({
              "outer_int": M.nt(initial: 2),
              "inner": M.inner(
                {
                  "inner_int": M.nt(),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
              ),
            }),
          ]),
        );
        expect(
          updated.value,
          equals([
            ModelInner({
              "outer_int": M.nt(initial: 5),
              "inner": M.inner(
                {
                  "inner_int": M.nt(),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
              ),
            }),
            ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(initial: 110),
                  "inner_dt": M.dt(initial: DateTime(2022)),
                },
              ),
            }),
          ]),
        );
        expect(updated.value, isNot(equals(mInL.value)));
      });
      test("Checking object value equality", () {
        expect(
          mInL,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "inner": {
                  "inner_int": 11,
                  "inner_dt": DateTime(2021),
                }
              },
              {
                "outer_int": 2,
              },
            ],
          )),
        );
        // checks if the fromIM constructor works
        expect(
          mInL,
          equals(ModelInnerList.fromIM(
            ImmutableModel({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            [
              {
                "inner": {
                  "inner_int": 11,
                  "inner_dt": DateTime(2021),
                }
              },
              {
                "outer_int": 2,
              },
            ],
          )),
        );
        expect(
          updated,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "outer_int": 5,
              },
              {
                "inner": {
                  "inner_int": 110,
                  "inner_dt": DateTime(2022),
                }
              },
            ],
          )),
        );
        // wrong order
        expect(
            updated,
            isNot(
              equals(M.inList(
                innerModel: ModelInner({
                  "outer_int": M.nt(initial: 1),
                  "inner": M.inner(
                    {
                      "inner_int": M.nt(validator: (n) => n >= 10),
                      "inner_dt": M.dt(initial: DateTime(2020)),
                    },
                    strictUpdates: true,
                  ),
                }),
                initial: [
                  {
                    "inner": {
                      "inner_int": 110,
                      "inner_dt": DateTime(2022),
                    }
                  },
                  {
                    "outer_int": 5,
                  },
                ],
              )),
            ));
        expect(updated, isNot(equals(mInL)));
      });
      test("Checking new instance generation", () {
        // invalid update returns the same model
        expect(
          inv,
          same(mInL),
        );
        // updating with a model should return that model instance
        expect(
          mInL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return a new instance (ModelInnerList specific)
        expect(
          updatedSame,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mInL,
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
      });
      test("Checking serialization", () {
        expect(
            serialized,
            equals([
              {
                "outer_int": 5,
                "inner": {
                  "inner_int": null,
                  "inner_dt": DateTime(2020).toIso8601String(),
                }
              },
              {
                "outer_int": 1,
                "inner": {
                  "inner_int": 110,
                  "inner_dt": DateTime(2022).toIso8601String(),
                }
              },
            ]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mInL.nextWithSerialized(serialized), equals(updated));
        expect(mInL, equals(mInL.nextWithSerialized("wrong")));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = ModelInner({'defsnotvalid': M.nt(initial: 1)});
        expect(
          vl,
          equals([
            ModelInner({
              "outer_int": M.nt(initial: 5),
              "inner": M.inner(
                {
                  "inner_int": M.nt(),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
              ),
            }),
            ModelInner({'defsnotvalid': M.nt(initial: 1)}),
          ]),
        );
        expect(
          updated,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "outer_int": 5,
              },
              {
                "inner": {
                  "inner_int": 110,
                  "inner_dt": DateTime(2022),
                }
              },
            ],
          )),
        );
      });
      test("Checking list append", () {
        expect(
          appended,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "outer_int": 5,
              },
              {
                "inner": {
                  "inner_int": 110,
                  "inner_dt": DateTime(2022),
                }
              },
              {
                "outer_int": 7,
              }
            ],
          )),
        );
        expect(appendedInv, equals(updated));
      });
      test("Checking list replaceAt", () {
        expect(
          replaced,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "outer_int": 55,
              },
              {
                "inner": {
                  "inner_int": 110,
                  "inner_dt": DateTime(2022),
                }
              },
            ],
          )),
        );
        expect(replacedInv, equals(updated));
      });
      test("Checking list removeAt", () {
        expect(
          removed,
          equals(M.inList(
            innerModel: ModelInner({
              "outer_int": M.nt(initial: 1),
              "inner": M.inner(
                {
                  "inner_int": M.nt(validator: (n) => n >= 10),
                  "inner_dt": M.dt(initial: DateTime(2020)),
                },
                strictUpdates: true,
              ),
            }),
            initial: [
              {
                "outer_int": 5,
              },
            ],
          )),
        );
      });
      test("Checking list sort", () {
        expect(
          sorted,
          equals(mInL.next([
            innerModel.nextWithUpdates({
              "inner": {
                "inner_int": 110,
                "inner_dt": DateTime(2022),
              }
            }),
            innerModel.nextWithUpdates({
              "outer_int": 5,
            }),
          ])),
        );
        expect(
          sorted,
          isNot(equals(mInL.next([
            innerModel.nextWithUpdates({
              "outer_int": 5,
            }),
            innerModel.nextWithUpdates({
              "inner": {
                "inner_int": 110,
                "inner_dt": DateTime(2022),
              }
            }),
          ]))),
        );
      });
    });
    group("ModelValueList", () {
      final mValL = M.mvList(
        defaultModel: ModelEmail("default@gmail.com"),
        initial: ["a@gmail.com", "b@gmail.com"],
      );
      // update the model a couple of times with valid values
      final updated = mValL.next([
        ModelEmail("c@gmail.com"),
        ModelEmail("d@gmail.com"),
      ]);
      // update the updated instance with the same value
      final updatedSame = updated.next([
        ModelEmail("c@gmail.com"),
        ModelEmail("d@gmail.com"),
      ]);
      // serialize the model
      final serialized = updated.asSerializable();

      final appended = updated.append([
        ModelEmail("e@gmail.com"),
        ModelEmail("f@gmail.com"),
      ]);
      final replaced = updated.replaceAt(
        1,
        (emailModel) => emailModel.next("replaced@gmail.com"),
      );
      final removed = updated.removeAt(1);

      test("Checking value access", () {
        expect(
            mValL.value,
            equals([
              ModelEmail("a@gmail.com"),
              ModelEmail("b@gmail.com"),
            ]));
        expect(
            updated.value,
            equals([
              ModelEmail("c@gmail.com"),
              ModelEmail("d@gmail.com"),
            ]));
        expect(
            updated.valueList,
            equals([
              "c@gmail.com",
              "d@gmail.com",
            ]));
        expect(updated[1], equals(ModelEmail("d@gmail.com")));
        expect(updated.valueAt(1), equals("d@gmail.com"));
        expect(updated.value, isNot(equals(mValL.value)));
      });
      test("Checking object value equality", () {
        expect(
            mValL,
            equals(ModelValueList(
              ModelEmail("default@gmail.com"),
              ["a@gmail.com", "b@gmail.com"],
            )));
        expect(
            updated,
            equals(ModelValueList(
              ModelEmail("default@gmail.com"),
              ["c@gmail.com", "d@gmail.com"],
            )));
        expect(updated, isNot(equals(mValL)));
      });
      test("Checking new instance generation", () {
        // updating with a model should return that model instance
        expect(
          mValL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mValL,
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
        // does not share a history with a new instance
        expect(
          updated.hasEqualityOfHistory(
            ModelValueList(
              ModelEmail("default@gmail.com"),
              ["a@gmail.com", "b@gmail.com"],
            ),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(
            serialized,
            equals([
              "c@gmail.com",
              "d@gmail.com",
            ]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mValL.nextWithSerialized(serialized), equals(updated));
        expect(mValL.nextWithSerialized("wrong"), equals(mValL));
        expect(
            mValL.nextWithSerialized(["notanemail1", "notanemail2"]),
            equals(
              ModelValueList.numberOfDefault(
                ModelEmail("default@gmail.com"),
                2,
              ),
            ));
      });
      test("Checking list internal mutation", () {
        final vl = updated.asList();
        vl[1] = ModelEmail('rand@gmail.com');
        expect(
            vl,
            equals([
              ModelEmail('c@gmail.com'),
              ModelEmail('rand@gmail.com'),
            ]));
        expect(
            updated.value,
            equals([
              ModelEmail("c@gmail.com"),
              ModelEmail("d@gmail.com"),
            ]));
      });
      test("Checking list append", () {
        expect(
            appended.value,
            equals([
              ModelEmail("c@gmail.com"),
              ModelEmail("d@gmail.com"),
              ModelEmail("e@gmail.com"),
              ModelEmail("f@gmail.com"),
            ]));
      });
      test("Checking list replaceAt", () {
        expect(
            replaced.value,
            equals([
              ModelEmail("c@gmail.com"),
              ModelEmail("replaced@gmail.com"),
            ]));
      });
      test("Checking list removeAt", () {
        expect(
            removed.value,
            equals([
              ModelEmail("c@gmail.com"),
            ]));
      });
    });
    group("ModelEnumList", () {
      final mEnmL = M.enmList<TestEnum>(
        enumValues: TestEnum.values,
        initial: [TestEnum.en1, TestEnum.en2],
      );
      // update the model a couple of times with valid values
      final updated =
          mEnmL.next([TestEnum.en1]).next([TestEnum.en2, TestEnum.en3]);
      // update the updated instance with the same value
      final updatedSame = updated.next([TestEnum.en2, TestEnum.en3]);
      final updatedEqu =
          mEnmL.next([TestEnum.en1]).next([TestEnum.en2, TestEnum.en3]);
      // serialize the model
      final serialized = updated.asSerializable();

      final updatedWithStrings = mEnmL.nextWithStrings(['en1', 'en3']);

      test("Checking value access", () {
        expect(mEnmL.value, equals([TestEnum.en1, TestEnum.en2]));
        expect(updated.value, equals([TestEnum.en2, TestEnum.en3]));
        expect(updated.value, isNot(equals(mEnmL.value)));
      });
      test("Checking object value equality", () {
        expect(
            mEnmL,
            equals(
              ModelEnumList<TestEnum>(
                TestEnum.values,
                [TestEnum.en1, TestEnum.en2],
              ),
            ));
        expect(
            updated,
            equals(
              ModelEnumList<TestEnum>(
                TestEnum.values,
                [TestEnum.en2, TestEnum.en3],
              ),
            ));
        expect(updated, updatedEqu);
        expect(updated, isNot(equals(mEnmL)));
      });
      test("Checking new instance generation", () {
        // updating with a model should return that model instance
        expect(
          mEnmL.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
        );
      });
      test("Checking equality of history", () {
        // shares a history with a direct ancestor
        expect(
          updated.hasEqualityOfHistory(
            mEnmL,
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
            ModelEnumList<TestEnum>(
              TestEnum.values,
              [TestEnum.en2, TestEnum.en3],
            ),
          ),
          false,
        );
      });
      test("Checking serialization", () {
        expect(serialized, equals(["en2", "en3"]));
      });
      test("Checking deserialisation", () {
        // deserializing should have the same value as update
        expect(mEnmL.nextWithSerialized(serialized), equals(updated));
        expect(mEnmL.nextWithSerialized("wrong"), equals(mEnmL));
        expect(mEnmL.nextWithSerialized(["wrong"]), equals(mEnmL));
      });
      test("Checking enum nextFromString", () {
        expect(updatedWithStrings.value, equals([TestEnum.en1, TestEnum.en3]));
      });
      test("Checking enum lists", () {
        expect(mEnmL.enums, equals(TestEnum.values));
        expect(mEnmL.enumStrings, equals(['en1', 'en2', 'en3']));
      });
    });
    // model enum
    group("ModelEnum:", () {
      final mEnm = M.enm<TestEnum>(
        enumValues: TestEnum.values,
        initial: TestEnum.en1,
      );
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

      final updatedFromString = mEnm.nextWithString('en2');

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
        // updating with a model should return that model instance
        expect(
          mEnm.nextFromModel(updated),
          same(updated),
        );
        // updating with the same value should return the same instance
        expect(
          updatedSame,
          same(updated),
        );
        // equivalent updates return a different instance
        expect(
          updatedEqu,
          isNot(same(updated)),
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
        expect(mEnm.nextWithSerialized(serialized), equals(updated));
        expect(mEnm.nextWithSerialized("wrong"), equals(mEnm));
      });
      test("Checking enum nextFromString", () {
        expect(updatedFromString.value, equals(TestEnum.en2));
      });
      test("Checking enum lists", () {
        expect(mEnm.enums, equals(TestEnum.values));
        expect(mEnm.enumStrings, equals(['en1', 'en2', 'en3']));
      });
    });
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
        "enum": M.enm(enumValues: TestEnum.values, initial: TestEnum.en1),
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
    final simpleModel = ImmutableModel({
      "an_int": M.nt(initial: 5),
      "a_dbl": M.dbl(initial: 0.5),
      "a_str": M.str(),
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
      // some invalid updates
      final updatedWithInv = updated.update({
        "prim_int": 9,
        "prim_double": (d) => d - 1.1,
        "list_int": [9, 12],
        "list_double": [0.4, 0.5]
      });

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
      // update the model with invalid values at the map level
      // i.e. between prim_int and prim_double
      expect(
        updated.update({
          "prim_double": 6.1,
        }),
        equals(updated),
      );
    });
    test("Checking strict updates", () {
      // attempt to update the inner without all fields
      expect(
        updated.update({
          "inner": {
            "prim_int": 5,
            "prim_str": "Hello",
          },
        }),
        equals(updated),
      );
      // attempt to update the inner with some invalid fields
      expect(
        updated.update({
          "inner": {
            "prim_int": 5,
            "prim_double": (d) => d - 1.1,
            "prim_str": "Hello"
          },
        }),
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
    test("Checking updateWithSelector", () {
      expect(
        updated.updateWithSelector(ModelSelector("list_int"), [6, 7]),
        equals(updated.update({
          "list_int": [6, 7]
        })),
      );
    });
    test("Checking updateWithSelectorIfIn", () {
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
    });
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
        model.fromJson(jsonDecode(jsonEncode(updated.toJson()))),
        equals(updated),
      );
      expect(
        model.fromJson(jsonDecode(jsonEncode(updated.toJsonDelta(model)))),
        equals(updated),
      );
    });
    test("Checking modelMap", () {
      final modelMap = simpleModel.modelMap;
      modelMap['extra'] = M.bl(initial: false);
      expect(
        simpleModel.modelMap,
        equals({
          "an_int": M.nt(initial: 5),
          "a_dbl": M.dbl(initial: 0.5),
          "a_str": M.str(),
        }),
      );
      expect(
        modelMap,
        equals({
          "an_int": M.nt(initial: 5),
          "a_dbl": M.dbl(initial: 0.5),
          "a_str": M.str(),
          "extra": M.bl(initial: false),
        }),
      );
    });
    test("Checking fieldLabels and numberOfFields", () {
      expect(simpleModel.fieldLabels, equals(["an_int", "a_dbl", "a_str"]));
      expect(simpleModel.numberOfFields, equals(3));
    });
    test("Checking model and value getters", () {
      expect(model.hasModel("list_str"), equals(true));
      expect(model.hasModel("random"), equals(false));
      expect(updated.getModel("prim_int"), equals(M.nt(initial: 5)));
      expect(updated.getValue("prim_int"), equals(5));
    });
    test("Checking model and value selector", () {
      final innerIntSel = ModelSelector<int>("inner.prim_int");
      expect(updated.selectModel(innerIntSel), equals(M.nt(initial: 5)));
      expect(updated.selectValue(innerIntSel), equals(5));
    });
    test("Checking join", () {
      final m = ImmutableModel<SomeState>(
        {
          "an_int": M.nt(initial: 2),
          "a_dbl": M.dbl(initial: 0.5),
        },
        modelValidator: (modelMap) =>
            modelMap["an_int"].value + modelMap["a_dbl"].value < 10,
        initialState: const SomeAState(),
      );
      final toJoin = ImmutableModel(
        {
          "an_int": M.nt(initial: 5),
          "a_str": M.str(initial: 'init'),
        },
        modelValidator: (modelMap) =>
            (modelMap["a_str"].value as String).length <=
            (modelMap["an_int"].value as int),
      );
      final joined = m.join(toJoin);
      expect(joined.fieldLabels, equals(['an_int', 'a_dbl', 'a_str']));
      expect(joined.currentState, equals(const SomeAState()));
      expect(joined['an_int'], equals(5));
      expect(joined['a_dbl'], equals(0.5));
      expect(joined['a_str'], equals('init'));
      // inv updates
      expect(
        joined.update({
          "an_int": 11,
        }),
        equals(joined),
      );
      expect(
        joined.update({
          "a_str": "longer",
        }),
        equals(joined),
      );
    });
    test("Checking restore", () {
      final restorableModel = ImmutableModel<SomeState>(
        {
          'an_int': M.nt(),
          'a_str': M.str(initial: "Hello"),
        },
        cacheBufferSize: 2,
        initialState: SomeAState(),
      );
      final update1 = restorableModel.update({
        'a_str': 'Foo',
      });
      final update2 = update1.transitionToAndUpdate(const SomeBState(), {
        'an_int': 1,
        'a_str': 'Bar',
      });
      final update3 = update2.update({
        'a_str': 'Foo',
      });
      expect(update3.restoreBy(1), equals(update2));
      // the cache buffer is shared between instances
      expect(update3.restoreBy(1), equals(update1));
      final reset = update3.resetAll();
      expect(() => reset.restoreBy(1), throwsA(TypeMatcher<Exception>()));
    });
  });
  group("Error tests:", () {
    test("Checking initial validation errors", () {
      expect(
        () => ModelInt(5, (n) => n < 2),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelDouble(
          0.5,
          (n) => n < 0.2,
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelString.text(''),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () =>
            ModelDateTime(DateTime(2020), (dt) => dt.isBefore(DateTime(1900))),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelEmail('notanemail'),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelPassword('invalid'),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelDateTime(
          DateTime(2020),
          (dt) => dt.isBefore(DateTime(1900)),
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelIntList(
          [4, 5],
          (i) => i < 1,
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelDoubleList(
          [0.4, 0.5],
          (i) => i < 0.1,
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelStringList(
          ['', 'hello'],
          (s) => s.isNotEmpty,
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ModelDateTimeList(
          [DateTime(2020), DateTime(2021)],
          (dt) => dt.isBefore(DateTime(1900)),
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
      expect(
        () => ImmutableModel(
          {
            'int': M.nt(initial: 1),
            "dbl": M.dbl(initial: 0.1),
          },
          modelValidator: (mm) => mm['dbl'].value > mm['int'].value,
        ),
        throwsA(TypeMatcher<ModelInitialValidationError>()),
      );
    });
    test("Checking model initialization errors", () {
      expect(
        () => ImmutableModel({}),
        throwsA(TypeMatcher<ModelInitializationError>()),
      );
      expect(
        () => ModelEnum([], TestEnum.en1),
        throwsA(TypeMatcher<ModelInitializationError>()),
      );
      expect(
        () => ModelEnum(TestEnum.values, null),
        throwsA(TypeMatcher<ModelInitializationError>()),
      );
    });
    test("Checking ModelTypeError", () {
      expect(
        () => ModelDateTime(DateTime(2020)).nextWithDynamic("wrong"),
        throwsA(TypeMatcher<ModelTypeError>()),
      );
      expect(
        () => ModelDoubleList([0.1, 0.2]).nextWithDynamic(['wrong', 'wrong']),
        throwsA(TypeMatcher<ModelTypeError>()),
      );
      expect(
        () => ModelEnum(TestEnum.values, TestEnum.en1).nextWithDynamic("wrong"),
        throwsA(TypeMatcher<ModelTypeError>()),
      );
    });
    test("Checking ModelEnumError", () {
      expect(
        () => ModelEnum(TestEnum.values, TestEnum.en1).nextWithString("wrong"),
        throwsA(TypeMatcher<ModelEnumError>()),
      );
    });
    test("Checking ModelInnerStrictUpdateError", () {
      expect(
        () {
          final m = ImmutableModel(
            {
              'int': M.nt(initial: 1),
              "dbl": M.dbl(initial: 0.1),
            },
            strictUpdates: true,
          );
          final sel = ModelSelector('int');
          m.updateWithSelector(sel, 2);
        },
        throwsA(TypeMatcher<ModelInnerStrictUpdateError>()),
      );
    });
    test("Checking ModelAccessError", () {
      expect(
        () => ImmutableModel(
          {
            'int': M.nt(initial: 1),
            "dbl": M.dbl(initial: 0.1),
          },
          strictUpdates: true,
        )['notinhere'],
        throwsA(TypeMatcher<ModelAccessError>()),
      );
    });
    test("Checking ModelSelectError", () {
      expect(
        () {
          final m = ImmutableModel(
            {
              'int': M.nt(initial: 1),
              "dbl": M.dbl(initial: 0.1),
              "inner": M.inner({
                "inner_int": M.nt(initial: 1),
              }),
            },
          );
          final sel = ModelSelector('int.inner_int');
          m.selectModel(sel);
        },
        throwsA(TypeMatcher<ModelSelectError>()),
      );
    });
    test("Checking ModelHistoryEqualityError", () {
      expect(
        () => ModelInt(1).nextFromModel(ModelInt(2)),
        throwsA(TypeMatcher<ModelHistoryEqualityError>()),
      );
    });
  });
}
