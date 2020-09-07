import '../../model_types.dart';
import '../model_types/model_primitive.dart';

class ModelEmail extends ModelPrimitive<String> {
  static final ValueValidator<String> validator = (emailStr) => RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
          caseSensitive: false)
      .hasMatch(emailStr);

  ModelEmail([String email, String fieldLabel = 'email']) : super.string(email, validator, fieldLabel);

  ModelEmail._constructNext(ModelEmail last, value) : super.constructNext(last, value);

  @override
  ModelEmail build(String value) => ModelEmail._constructNext(this, value);

  @override
  bool hasEqualityOfHistory(ModelValue other) => other is ModelEmail;
}
