import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [int].
class ModelInt extends ModelValueType<ModelInt, int> {
  ModelInt(
    int? initialValue, {
    Validator<int>? validator,
    required String fieldLabel,
  }) : super.initial(
          initialValue,
          validator: validator,
          fieldLabel: fieldLabel,
        );

  ModelInt._next(ModelInt previous, int nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);
}
