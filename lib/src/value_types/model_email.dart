import '../m.dart';
import '../model_types/model_primitive.dart';
import '../model_types/model_value.dart';

class ModelEmail extends ModelPrimitive<String> {
  ModelEmail([String defaultEmail, String fieldName = 'email'])
      : super.string(
            defaultEmail,
            (email_str) => RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
                    caseSensitive: false)
                .hasMatch(email_str),
            fieldName);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelEmail;
}

extension EmailValue on M {
  static ModelEmail email([String defaultEmail]) => ModelEmail(defaultEmail);
}
