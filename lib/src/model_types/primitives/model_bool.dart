import 'model_value_type.dart';

/// A model for a [bool]. This class needs no validator.
class ModelBool extends ModelValueType<ModelBool, bool> {
  ModelBool(
    String fieldLabel,
    bool initialValue,
  ) : super.initial(fieldLabel, initialValue);

  ModelBool._next(ModelBool previous, bool nextValue)
      : super.constructNext(previous, nextValue);

  @override
  ModelBool buildNext(bool nextValue) => ModelBool._next(this, nextValue);
}
