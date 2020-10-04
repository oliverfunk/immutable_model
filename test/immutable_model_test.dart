import 'package:test/test.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

void main() {
  group("ImmutableModel and ModelType tests", () {
    final mBool = M.bl(initialValue: false);
    final mInt = M.nt(initialValue: 1);
    final mDbl = M.dbl(initialValue: 0.1);
    final mStr = M.str();
    final mTxt = M.txt(initialValue: "Hello");
    final mDt = M.dt(initialValue: DateTime(2020));

    final model = ImmutableModel({
      "bool": mBool,
      "int": mInt,
      "double": mDbl,
      "string": mStr,
      "text": mTxt,
      "date_time": mDt,
    });

    group("ModelType object tests", () {
      test("ModelType value equalities", () {
        expect(mBool, ModelBool(initialValue: false));
        expect(mInt, ModelInt(initialValue: 1));
        expect(mDbl, ModelDouble(initialValue: 0.1));
        expect(mStr, ModelString(initialValue: null));
        expect(mTxt, ModelString.text(initialValue: "Hello"));
        expect(mDt, ModelDateTime(initialValue: DateTime(2020)));
      });
    });

    group("model definition with M", () {});

    group("model updates and resets", () {});

    group("model JSON handling", () {});
  });
}
