import '../model_value.dart';
import '../model_types/model_primitive.dart';

class ModelText extends ModelPrimitive<String> {
  ModelText([String value, bool Function(String) validator, String fieldLabel])
      : super.string(value, (str) => str != null && str != '', fieldLabel);

  @override
  ModelText build(String value) => ModelText(value);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelText;
}
