import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [int].
class ModelInt extends ModelValueType<ModelInt, int> {
  ModelInt(
    int? initialValue, {
    Validator<int>? validator,
    required String label,
  }) : super.initial(
          initialValue,
          validator: validator,
          label: label,
        );

  ModelInt._next(ModelInt previous, int nextValue)
      : super.constructNext(previous, nextValue);

  @override
  @protected
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);
}
