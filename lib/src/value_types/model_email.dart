import '../model_value.dart';
import '../model_types/model_primitive.dart';

// a value type wraps its own validation

class ModelEmail extends ModelPrimitive<String> {
  static final validator = (emailStr) => RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
          caseSensitive: false)
      .hasMatch(emailStr);

  ModelEmail([String defaultEmail, String fieldLabel = 'email']) : super.string(defaultEmail, validator, fieldLabel);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelEmail;
}
