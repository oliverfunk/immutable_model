import 'package:built_collection/built_collection.dart';

import 'model_value.dart';

class ImmutableModel extends ModelValue<ImmutableModel, Map<String, dynamic>> {
  // FIFO cache <ImmuModl>

  final BuiltMap<String, ModelValue> _currentModel;
  final Map<String, ModelValue> _initialModel;

  ImmutableModel._(ImmutableModel last, this._currentModel) : _initialModel = last._initialModel;

  ImmutableModel(Map<String, ModelValue> model)
      : _initialModel = model,
        _currentModel = BuiltMap.of(model);

  @override
  ImmutableModel build(Map<String, dynamic> updates) => updates == null
      ? ImmutableModel(this._initialModel)
      : ImmutableModel._(this, _currentModel.rebuild((mb) {
          updates.forEach((field, value) {
            mb.updateValue(field, (curr_val) => curr_val.updateFrom(value));
          });
        }));

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(this, _currentModel.rebuild((mb) {
        fields.forEach((field) {
          mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  @override
  Map<String, dynamic> get value => _currentModel.map((field, value) => MapEntry(field, value.value)).toMap();

  dynamic getFieldValue(String field) => _currentModel[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  @override
  Map<String, dynamic> asSerializable() =>
      _currentModel.map((field, value) => MapEntry(field, value.asSerializable())).asMap();

  @override
  String toString() => _currentModel.toString();
}
