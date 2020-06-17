import 'package:equatable/equatable.dart';

import 'buffer.dart';
import 'exceptions.dart';
import 'model_types/model_inner.dart';
import 'model_types/model_value.dart';

class ImmutableModel extends Equatable {
  final ModelInner _model;
  final CacheBuffer<ImmutableModel> _cache;

  ImmutableModel._(ImmutableModel last, this._model) : _cache = last._cache {
    _cache.cacheItem(last);
  }

  ImmutableModel(Map<String, ModelValue> model,
      [UpdateValidator updateValidator, int cacheBufferSize = 0])
      : _model = ModelInner(model, updateValidator),
        _cache = CacheBuffer(cacheBufferSize);

  // caching

  ImmutableModel restoreTo(int point) => _cache.restoreTo(point);

  // value

  Map<String, dynamic> asMap() => _model.value;

  // updating

  ImmutableModel update(Map<String, dynamic> updates) =>
      (updates == null || updates.isEmpty)
          ? this
          : ImmutableModel._(this, _model.next(updates));

  /// ensure valid _structural_ update
  ImmutableModel strictUpdate(Map<String, dynamic> updates) {
    if (_model.numberOfFields() == updates.length) {
      // not that efficient
      updates.keys.forEach((field) {
        if (!_model.hasField(field)) {
          throw ModelStrictUpdateException("Field $field not in model");
        }
      });
    } else {
      throw ModelStrictUpdateException(
          "Fields in updates not the same as model");
    }

    return update(updates);
  }

  ImmutableModel updateWith(Map<String, ValueUpdater> updaters) =>
      (updaters == null || updaters.isEmpty)
          ? this
          : ImmutableModel._(this, _model.next(updaters));

  ImmutableModel updateWithModels(Map<String, ModelValue> models) =>
      (models == null || models.isEmpty)
          ? this
          : ImmutableModel._(this, _model.next(models));

  ImmutableModel updateModel(ModelInner model) => model == null
      ? this
      : ImmutableModel._(this, _model.nextFromModel(model));

  ImmutableModel resetFields(List<String> fields) =>
      (fields == null || fields.isEmpty)
          ? this
          : ImmutableModel._(
              this,
              _model.next(Map.fromIterable(fields,
                  key: (listItem) => listItem, value: null)));

  // JSON

  Map<String, dynamic> toJson() => _model.asSerializable();

  ImmutableModel fromJson(Map<String, dynamic> jsonMap) =>
      (jsonMap == null || jsonMap.isEmpty)
          ? this
          : ImmutableModel._(this, _model.fromJSON(jsonMap));

  // field ops

  Iterable<String> get fields => _model.fields;

  int numberOfFields() => _model.numberOfFields();

  bool hasField(String field) => _model.hasField(field);

  ModelValue getFieldModel(String field) => _model.getFieldModel(field);

  dynamic getFieldValue(String field) => _model.getFieldValue(field);

  dynamic operator [](String field) => getFieldValue(field);

  // misc

  @override
  List<Object> get props => [_model];

  @override
  String toString() => _model.toString();
}
