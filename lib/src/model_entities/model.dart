import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/model_entity.dart';

typedef dynamic ValueUpdater(dynamic currentValue);

class Model extends ModelEntity<Model, Map<String, dynamic>> {
  final BuiltMap<String, ModelEntity> _model;
  final BuiltMap<String, ModelEntity> _defaultModel;

  // constructors
  Model._(Model instance, this._model) : _defaultModel = instance._defaultModel;

  Model(Map<String, ModelEntity> defaultModel)
      : _model = null,
        _defaultModel = BuiltMap.of(defaultModel);

  // private helper class methods
  BuiltMap<String, ModelEntity> _safeMapInstance() => (_model ?? _defaultModel);

  // immutable entity methods
  @override
  Map<String, dynamic> get value =>
      _safeMapInstance().toMap().map<String, dynamic>((key, value) => MapEntry(key, value.value));

  @override
  Map<String, dynamic> validate(Map<String, dynamic> updates) => updates;

  @override
  Model build(Map<String, dynamic> updates) => updates == null
      ? Model._(this, null)
      : Model._(
          this,
          _safeMapInstance().rebuild((mb) {
            updates.forEach((field, value) {
              mb.updateValue(field, (cv) => cv.updateWith(value));
            });
          }));

  @override
  Map<String, dynamic> deserialize(entity) => entity is Map<String, dynamic> ? entity : throw Exception('not map');

  @override
  Map<String, dynamic> asSerializable() =>
      _safeMapInstance().toMap().map<String, dynamic>((key, value) => MapEntry(key, value.asSerializable()));

  // class methods
  dynamic getValue(String field) => _safeMapInstance()[field].value;

  dynamic operator [](String field) => getValue(field);

  ModelEntity getEntity(String field) => _safeMapInstance()[field];

  Map<String, ModelEntity> asEntityMap() => _safeMapInstance().asMap();

  Model updateWithFunctions(Map<String, ValueUpdater> updateFuncs) => Model._(
      this,
      _safeMapInstance().rebuild((mb) {
        updateFuncs.forEach((field, func) {
          mb.updateValue(field, (cv) => cv.updateWith(func(cv.value)));
        });
      }));

  Model updateFrom(Map<String, dynamic> updates) => Model._(
      this,
      _safeMapInstance().rebuild((mb) {
        updates.forEach((field, value) {
          if (_safeMapInstance().containsKey(field)) mb.updateValue(field, (cv) => cv.updateWith(value));
        });
      }));

  Model resetFields(List<String> fields) => Model._(
      this,
      _safeMapInstance().rebuild((mb) {
        fields.forEach((field) {
          if (_safeMapInstance().containsKey(field)) mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  @override
  String toString() => _safeMapInstance().toString();
}
