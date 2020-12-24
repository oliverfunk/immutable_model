import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import 'model_value_type.dart';

/// A model for a validated [double].
class ModelDouble extends ModelValueType<ModelDouble, double> {
  ModelDouble(
    double? initialValue, {
    Validator<double>? validator,
    required String label,
  }) : super.initial(
          initialValue,
          validator: validator,
          label: label,
        );

  ModelDouble._next(ModelDouble previous, double nextValue)
      : super.constructNext(previous, nextValue);

  @override
  @protected
  ModelDouble buildNext(double nextValue) => ModelDouble._next(this, nextValue);
}
