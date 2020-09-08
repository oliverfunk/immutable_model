import '../model_type.dart';
import '../model_value.dart';

class ModelBool extends ModelValue<ModelBool, bool> {
  ModelBool([
    bool initialValue,
    String fieldLabel,
  ]) : super.bool(initialValue, fieldLabel);

  ModelBool._next(ModelBool previous, bool value) : super.constructNext(previous, value);

  @override
  ModelBool buildNext(bool nextValue) => ModelBool._next(this, nextValue);
}

class ModelInt extends ModelValue<ModelInt, int> {
  ModelInt([
    int initialValue,
    ValueValidator<int> validator,
    String fieldLabel,
  ]) : super.int(initialValue, validator, fieldLabel);

  ModelInt._next(ModelInt previous, int value) : super.constructNext(previous, value);

  @override
  ModelInt buildNext(int nextValue) => ModelInt._next(this, nextValue);
}

class ModelDouble extends ModelValue<ModelDouble, double> {
  ModelDouble([
    double initialValue,
    ValueValidator<double> validator,
    String fieldLabel,
  ]) : super.double(initialValue, validator, fieldLabel);

  ModelDouble._next(ModelDouble previous, double value) : super.constructNext(previous, value);

  @override
  ModelDouble buildNext(double nextValue) => ModelDouble._next(this, nextValue);
}

class ModelString extends ModelValue<ModelString, String> {
  ModelString([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ]) : super.string(initialValue, validator, fieldLabel);

  ModelString.text([
    String initialValue,
    ValueValidator<String> validator,
    String fieldLabel,
  ]) : super.text(initialValue, validator, fieldLabel);

  ModelString._next(ModelString previous, String value) : super.constructNext(previous, value);

  @override
  ModelString buildNext(String nextValue) => ModelString._next(this, nextValue);
}

class ModelDateTime extends ModelValue<ModelDateTime, DateTime> {
  ModelDateTime([
    DateTime initialValue,
    ValueValidator<DateTime> validator,
    String fieldLabel,
  ]) : super.datetime(initialValue, validator, fieldLabel);

  ModelDateTime._next(ModelDateTime previous, DateTime value) : super.constructNext(previous, value);

  @override
  ModelDateTime buildNext(DateTime nextValue) => ModelDateTime._next(this, nextValue);

  @override
  String asSerializable() => value.toIso8601String();

  @override
  DateTime fromSerialized(dynamic serialized) => serialized is String ? DateTime.parse(serialized) : null;
}
