import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/buffer.dart';

import 'model_value.dart';

class ImmutableModel extends ModelValue<ImmutableModel, Map<String, dynamic>> {
  final BuiltMap<String, ModelValue> _currentModel;
  final Map<String, ModelValue> _initialModel;
  final CacheBuffer<ImmutableModel> _cache;

  ImmutableModel._(ImmutableModel last, this._currentModel)
      : _initialModel = last._initialModel,
        _cache = last._cache;

  ImmutableModel(Map<String, ModelValue> model, [int cacheBufferSize = 5])
      : _initialModel = model,
        _currentModel = BuiltMap.of(model),
        _cache = CacheBuffer(cacheBufferSize);

  @override
  ImmutableModel build(Map<String, dynamic> updates) => updates == null
      ? ImmutableModel(this._initialModel, this._cache.bufferSize)
      : () {
          _cache.cacheItem(this);
          return ImmutableModel._(this, _currentModel.rebuild((mb) {
            updates.forEach((field, value) {
              mb.updateValue(field, (currVal) => currVal.updateFrom(value));
            });
          }));
        }();

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

  ImmutableModel restoreTo(int point) => _cache.restoreTo(point);

  @override
  String toString() => _currentModel.toString();
}
