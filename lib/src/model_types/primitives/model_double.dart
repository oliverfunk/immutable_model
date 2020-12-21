import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [double].
class ModelDouble extends ModelValueType<ModelDouble, double> {
  ModelDouble(
    String fieldLabel,
    double initialValue, [
    Validator<double>? validator,
  ]) : super.initial(fieldLabel, initialValue, validator);

  ModelDouble._next(ModelDouble previous, double nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelDouble buildNext(double nextValue) => ModelDouble._next(this, nextValue);
}
