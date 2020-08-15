import '../model_value.dart';
import '../model_types/model_primitive.dart';

class ModelEmail extends ModelPrimitive<String> {
  ModelEmail([String defaultEmail, String fieldName = 'email'])
      : super.string(
            defaultEmail,
            (emailStr) => RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
                    caseSensitive: false)
                .hasMatch(emailStr),
            fieldName);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelEmail;
}
