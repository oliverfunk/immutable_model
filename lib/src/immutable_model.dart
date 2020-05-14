import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/buffer.dart';

import 'model_value.dart';

class ImmutableModel extends ModelValue<ImmutableModel, Map<String, dynamic>> {
  final BuiltMap<String, ModelValue> _currentModel;
  final BuiltMap<String, ModelValue> _initialModel;
  final CacheBuffer<ImmutableModel> _cache;

  ImmutableModel._(ImmutableModel last, this._currentModel)
      : _initialModel = last._initialModel,
        _cache = last._cache;

  ImmutableModel(Map<String, ModelValue> model, [int cacheBufferSize = 5])
      : _currentModel = null,
        _initialModel = BuiltMap.of(model),
        _cache = CacheBuffer(cacheBufferSize);

  BuiltMap<String, ModelValue> _safeInstance() => _currentModel ?? _initialModel;

  @override
  ImmutableModel build(Map<String, dynamic> updates) {
    if (updates == null) {
      // reset
      _cache.flush();
      return ImmutableModel._(this, _initialModel);
    } else {
      _cache.cacheItem(this);
      return ImmutableModel._(
          this,
          _safeInstance().rebuild((mb) {
            updates.forEach((field, value) {
              mb.updateValue(field, (currVal) => currVal.updateFrom(value));
            });
          }));
    }
  }

  ImmutableModel resetFields(List<String> fields) => ImmutableModel._(
      this,
      _safeInstance().rebuild((mb) {
        fields.forEach((field) {
          mb.updateValue(field, (cv) => cv.reset());
        });
      }));

  // not efficient
  @override
  Map<String, dynamic> get value => _safeInstance().toMap().map((field, value) => MapEntry(field, value.value));

  dynamic getFieldValue(String field) => _safeInstance()[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  // not efficient
  @override
  Map<String, dynamic> asSerializable() =>
      Map.unmodifiable(_safeInstance().toMap().map((field, value) => MapEntry(field, value.asSerializable())));

  ImmutableModel restoreTo(int point) => _cache.restoreTo(point);

  @override
  List<Object> get props => [_safeInstance()];

  @override
  String toString() => _safeInstance().toString();
}
