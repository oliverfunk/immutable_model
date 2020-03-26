import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/model_entity.dart';

import '../immutable_entity.dart';

typedef dynamic ValueUpdater(dynamic currentValue);
class ImmutableModel extends ImmutableEntity<ImmutableModel, Map<String, dynamic>> {
  final BuiltMap<String, ModelEntity> _model;
  final BuiltMap<String, ModelEntity> _defaultModel;

  // constructors
  ImmutableModel._(ImmutableModel instance, this._model) : _defaultModel = instance._defaultModel;

  ImmutableModel(Map<String, ModelEntity> defaultModel)
      : _model = null,
        _defaultModel = BuiltMap.of(defaultModel);

  // private helper class methods
  BuiltMap<String, ModelEntity> _safeMapInstance() => (_model ?? _defaultModel);

  // immutable entity methods
  @override
  Map<String, dynamic> get value =>
      _safeMapInstance().toMap().map<String, dynamic>((key, value) => MapEntry(key, value.value()));

  @override
  Map<String, dynamic> validate(Map<String, dynamic> updates) => updates;

  @override
  ImmutableModel build(Map<String, dynamic> updates) => updates == null
      ? ImmutableModel._(this, null)
      : ImmutableModel._(
          this,
          _safeMapInstance().rebuild((mb) {
            updates.forEach((field, value) {
              mb.updateValue(field, (cv) => cv.updateWith(value));
            });
          }));

  // class methods
  dynamic getValue(String field) => _model[field].value;

  dynamic operator [](String field) => getValue(field);

  Map<String, ModelEntity> asEntityMap() => _safeMapInstance().toMap();

  Map<String, dynamic> asSerializableMap() =>
      _safeMapInstance().toMap().map<String, dynamic>((key, value) => MapEntry(key, value.asSerializable()));

  ImmutableModel updateWithFunctions(Map<String, ValueUpdater> updateFuncs) => ImmutableModel._(
      this,
      _safeMapInstance().rebuild((mb) {
        updateFuncs.forEach((field, func) {
          mb.updateValue(field, (cv) => cv.updateWith(func(cv.value)));
        });
      }));

  ImmutableModel updateFrom(Map<String, dynamic> updates) => ImmutableModel._(
      this,
      _safeMapInstance().rebuild((mb) {
        updates.forEach((field, value) {
          if (_safeMapInstance().containsKey(field)) mb.updateValue(field, (cv) => cv.updateWith(value));
        });
      }));

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(
      this,
      _safeMapInstance().rebuild((mb) {
        fields.forEach((field) {
          if (_safeMapInstance().containsKey(field)) mb.updateValue(field, (cv) => cv.reset());
        });
      }));
}
