import 'package:test/test.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

void main() {
  final mBool = M.bl(initialValue: false);
  final mInt = M.nt(initialValue: 1);
  final mDbl = M.dbl(initialValue: 0.1);
  final mStr = M.str();
  final mTxt = M.txt(initialValue: "Hello");
  final mDt = M.dt(initialValue: DateTime.now());

  final model = ImmutableModel({
    "bool": mBool,
    "int": mInt,
    "double": mDbl,
    "string": mStr,
    "text": mTxt,
    "date_time": mDt,
  });
  group("ModelType object tests", () {
    test("Value Equalities", () {
      expect(model.getModel('outer_bool'), ModelBool(initialValue: false));
      expect(mInt, ModelInt(initialValue: 1));
    });
  });

  group("model definition with M", () {});

  group("model updates and resets", () {});

  group("model JSON handling", () {});
}
