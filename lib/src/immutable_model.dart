import 'buffer.dart';
import 'model_inner.dart';
import 'model_value.dart';

// todo: update from Models

class ImmutableModel {
  final ModelInner _model;
  final CacheBuffer<ImmutableModel> _cache;

  ImmutableModel._(ImmutableModel last, this._model) : _cache = last._cache {
    _cache.cacheItem(last);
  }

  ImmutableModel(Map<String, ModelValue> model, [int cacheBufferSize = 0])
      : _model = ModelInner(model),
        _cache = CacheBuffer(cacheBufferSize);

  ImmutableModel restoreTo(int point) => _cache.restoreTo(point);

  ImmutableModel update(Map<String, dynamic> updates) =>
      (updates == null || updates.isEmpty) ? this : ImmutableModel._(this, _model.next(updates));

  /// ensure valid _structural_ update
  ImmutableModel strictUpdate(Map<String, dynamic> updates) {
    if (_model.numberOfFields() == updates.length) {
      // not that efficient
      updates.keys.forEach((field) {
        if (!_model.hasField(field)) {
          throw Exception("Field $field not in model");
        }
      });
    } else {
      throw Exception("Fields in updates not the same as model");
    }

    return update(updates);
  }

  ImmutableModel updateWith(Map<String, FieldUpdater> updaters) =>
      (updaters == null || updaters.isEmpty) ? this : ImmutableModel._(this, _model.next(updaters));

  ImmutableModel resetFields(List<String> fields) => (fields == null || fields.isEmpty)
      ? this
      : ImmutableModel._(this, _model.next(Map.fromIterable(fields, key: (listItem) => listItem, value: null)));

  ModelValue getFieldModel(String field) => _model.getFieldModel(field);

  dynamic getFieldValue(String field) => _model.getFieldValue(field);

  dynamic operator [](String field) => getFieldValue(field);

  Iterable<String> get fields => _model.fields;

  ImmutableModel fromJSON(Map<String, dynamic> jsonMap) => (jsonMap == null || jsonMap.isEmpty) ? this : ImmutableModel._(this, _model.fromJSON(jsonMap));

  @override
  String toString() => _model.toString();
}
