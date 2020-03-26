import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/v2/immutable_entities/immutable_entity.dart';
import 'package:immutable_model/src/v2/model_entities/model_entity.dart';

class ImmutableModel extends ImmutableEntity<Map<String, dynamic>> {
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
  Map<String, ModelEntity> get value => _safeMapInstance().toMap();

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

  void testPrint() {
    print("PLEASE GZUZ LET THIS ABSTRACTION WORK!");
  }
}
