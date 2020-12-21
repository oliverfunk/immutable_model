import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [int].
class ModelInt extends ModelValueType<ModelInt, int> {
  ModelInt(
    String fieldLabel,
    int initialValue, [
    Validator<int>? validator,
  ]) : super.initial(fieldLabel, initialValue, validator);

  ModelInt._next(ModelInt previous, int nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);
}
