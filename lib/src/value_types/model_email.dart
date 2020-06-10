import '../model_types/model_primitive.dart';
import '../model_types/model_value.dart';

class ModelEmail extends ModelPrimitive<String> {
  ModelEmail([String initialValue])
      : super(initialValue, (email_str) => email_str.length > 1, 'email');

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelEmail;
}
