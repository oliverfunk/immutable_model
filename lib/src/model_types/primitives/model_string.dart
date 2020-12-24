import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [String].
class ModelString extends ModelValueType<ModelString, String> {
  ModelString(
    String? initialValue, {
    Validator<String>? validator,
    required String fieldLabel,
  }) : super.initial(
          initialValue,
          validator: validator,
          fieldLabel: fieldLabel,
        );

  ModelString._next(ModelString previous, String nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);
}
