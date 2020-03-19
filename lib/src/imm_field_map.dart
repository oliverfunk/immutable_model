import 'package:immutable_model/src/immutable_model.dart';

class ImmutableFieldModel extends ImmutableFieldValue<ImmutableModel> {
  ImmutableModel _value;
  @override
  ImmutableModel get value => _value ?? defaultValue;

  @override
  final ImmutableModel defaultValue;

  ImmutableFieldModel._(ImmutableFieldModel m, this._value) : defaultValue = m.defaultValue;

  ImmutableFieldModel(Map<String, ImmutableFieldValue> defaultModel) : defaultValue = ImmutableModel(defaultModel);

  @override
  Map<String, dynamic> asSerializable() => value.asMap();

  @override
  ImmutableFieldModel setWithParse(dynamic v) => v is Map<String, dynamic>
      ? set(value.updateWith(v))
      : throw Exception('v is ${v.runtimeType} not Map<String, dynamic>, with:\n$v');

  @override
  ImmutableFieldModel set(ImmutableModel v) => ImmutableFieldModel._(this, v);

  @override
  ImmutableFieldModel reset() => ImmutableFieldModel._(this, null);

  @override
  String toString() => value.toString();
}

class ImmutableFieldList<T> extends ImmutableFieldValue<List<T>> {

}