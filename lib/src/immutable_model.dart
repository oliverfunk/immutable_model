import 'package:built_collection/built_collection.dart';

import 'immutable_model_value.dart';

class ImmutableModel {
  final BuiltMap<String, ImmutableModelValue> _model;

  ImmutableModel._(this._model);

  ImmutableModel(Map<String, ImmutableModelValue> model) : _model = BuiltMap.of(model);

  ImmutableModel updateWith(Map<String, dynamic> updates) => ImmutableModel._(_model.rebuild((mb) {
        updates.forEach((field, value) {
          mb.updateValue(field, (cv) => cv.setFrom(value));
        });
      }));

  ImmutableModel updateFrom(Map<String, dynamic> updates) => ImmutableModel._(_model.rebuild((mb) {
        updates.forEach((field, value) {
          if (_model.containsKey(field)) mb.updateValue(field, (cv) => cv.setFrom(value));
        });
      }));

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(_model.rebuild((mb) {
        fields.forEach((field) {
          mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  ImmutableModel resetAll() => ImmutableModel._(_model.rebuild((mb) => mb.updateAllValues((k, v) => v.reset())));

  dynamic getValue(String field) => _model[field].value;
  dynamic operator [](String field) => getValue(field);

  Map<String, ImmutableModelValue> asMap() => _model.asMap();

  /// Returns an moidifbale serilasibed version of the model
  Map<String, dynamic> asSerializable() =>
      Map<String, dynamic>.unmodifiable(Map<String, dynamic>.fromIterable(_model.entries,
          key: (entry) => entry.key, value: (entry) => entry.value.asSerializable()));

  @override
  String toString() => _model.toString();
}
