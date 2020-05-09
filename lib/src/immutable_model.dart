import 'package:built_collection/built_collection.dart';

import 'model_value.dart';

class ImmutableModel extends ModelValue<ImmutableModel, Map<String, dynamic>> {
  // FIFO cache <ImmuModl>

  final BuiltMap<String, ModelValue> _model;
  final Map<String, ModelValue> _default;

  ImmutableModel._(ImmutableModel last, this._model) : _default = last._default;

  ImmutableModel(Map<String, ModelValue> model)
      : _default = model,
        _model = BuiltMap.of(model);

  @override
  ImmutableModel build(Map<String, dynamic> updates) => updates == null
      ? ImmutableModel(this._default)
      : ImmutableModel._(this, _model.rebuild((mb) {
          updates.forEach((field, value) {
            mb.updateValue(field, (curr_val) => curr_val.updateFrom(value));
          });
        }));

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(this, _model.rebuild((mb) {
        fields.forEach((field) {
          mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  @override
  Map<String, dynamic> get value => _model.map((field, value) => MapEntry(field, value.value)).toMap();

  dynamic getFieldValue(String field) => _model[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  @override
  Map<String, dynamic> asSerializable() =>
      _model.map((field, value) => MapEntry(field, value.asSerializable())).asMap();

  @override
  String toString() => _model.toString();
}
