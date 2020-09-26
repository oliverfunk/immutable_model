import '../model_type.dart';
import '../model_value.dart';

class ModelEmail extends ModelValue<ModelEmail, String> with ValueType {
  static final ValueValidator<String> validator = (emailStr) => RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
          caseSensitive: false)
      .hasMatch(emailStr);

  ModelEmail([String defaultEmail, String fieldLabel = 'email']) : super.text(defaultEmail, validator, fieldLabel);

  ModelEmail._next(ModelEmail previous, String value) : super.constructNext(previous, value);

  @override
  ModelEmail buildNext(String nextValue) => ModelEmail._next(this, nextValue);
}
