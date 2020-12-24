import 'package:meta/meta.dart';

import 'model_value_type.dart';

/// A model for a [bool]. This class needs no validator.
class ModelBool extends ModelValueType<ModelBool, bool> {
  ModelBool(
    bool? initialValue, {
    required String label,
  }) : super.initial(
          initialValue,
          label: label,
        );

  ModelBool._next(ModelBool previous, bool nextValue)
      : super.constructNext(previous, nextValue);

  @override
  @protected
  ModelBool buildNext(bool nextValue) => ModelBool._next(this, nextValue);
}
