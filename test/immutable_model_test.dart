import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:test/test.dart';

void main() {
  group("ModelType object tests", () {
    test("Value Equalities", () {
      final mBool = ModelBool(initialValue: false);
      final mInt = ModelInt(initialValue: 1);

      expect(mBool, ModelBool(initialValue: false));
      expect(mInt, ModelInt(initialValue: 1));
    });
  });

  group("model definition with M", () {
    final model = ImmutableModel({
      "outer_bool": M.bl(initialValue: false),
      "outer_int": M.nt(initialValue: 1),
      "outer_double": M.dbl(initialValue: 0.1),
    });
  });

  group("model updates and resets", () {});

  group("model JSON handling", () {});
}
