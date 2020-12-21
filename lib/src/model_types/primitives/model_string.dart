import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [String].
class ModelString extends ModelValueType<ModelString, String> {
  ModelString(
    String fieldLabel,
    String initialValue, [
    Validator<String>? validator,
  ]) : super.initial(fieldLabel, initialValue, validator);

  ModelString._next(ModelString previous, String nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);
}
