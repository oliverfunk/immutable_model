import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [String].
class ModelString extends ModelValueType<ModelString, String> {
  ModelString(
    String? initialValue, {
    Validator<String>? validator,
    required String label,
  }) : super.initial(
          initialValue,
          validator: validator,
          label: label,
        );

  ModelString.text(
    String? initialValue, {
    Validator<String>? validator,
    required String label,
  }) : super.initial(
          initialValue,
          validator: validator == null
              ? (s) => s.isNotEmpty
              : (s) => s.isNotEmpty && validator(s),
          label: label,
        );

  ModelString._next(ModelString previous, String nextValue)
      : super.constructNext(previous, nextValue);

  @override
  @protected
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);
}
