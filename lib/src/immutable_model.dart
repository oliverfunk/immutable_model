import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/buffer.dart';

import 'model_value.dart';

typedef dynamic FieldUpdater(dynamic currentValue);

class ImmutableModel extends ModelValue<ImmutableModel, Map<String, dynamic>> {
  final BuiltMap<String, ModelValue> _currentModel;
  final BuiltMap<String, ModelValue> _initialModel;
  final CacheBuffer<ImmutableModel> _cache;

  ImmutableModel._(ImmutableModel last, this._currentModel)
      : _initialModel = last._initialModel,
        _cache = last._cache {
    _cache.cacheItem(last);
  }

  ImmutableModel(Map<String, ModelValue> model, [int cacheBufferSize = 0])
      : _currentModel = null,
        _initialModel = BuiltMap.of(model),
        _cache = CacheBuffer(cacheBufferSize);

  BuiltMap<String, ModelValue> _safeInstance() => _currentModel ?? _initialModel;

  @override
  ImmutableModel build(Map<String, dynamic> updates) {
    if (updates == null) {
      // reset, clear cache
      _cache.flush();
      return ImmutableModel._(this, _initialModel);
    } else if (updates.isEmpty) {
      return this;
    } else {
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

  ModelValue getFieldModel(String field) => _safeInstance()[field];

  dynamic getFieldValue(String field) => _safeInstance()[field].value;

  dynamic operator [](String field) => getFieldValue(field);

  ImmutableModel updateFieldsWith(Map<String, FieldUpdater> updaters) {
    if (updaters == null || updaters.isEmpty) {
      return this;
    } else {
      return ImmutableModel._(
          this,
          _safeInstance().rebuild((mb) {
            updaters.forEach((field, updater) {
              mb.updateValue(field, (currVal) => currVal.updateFrom(updater(currVal.value)));
            });
          }));
    }
  }

  /// ensure valid _structural_ update
  ImmutableModel strictUpdate(Map<String, dynamic> updates) {
    if (_safeInstance().length == updates.length) {
      // not that efficient
      updates.keys.forEach((field) {
        if (!_safeInstance().containsKey(field)) {
          throw Exception("Field $field not in model");
        }
      });
    } else {
      throw Exception("Fields in updates not the same as model");
    }

    return update(updates);
  }

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
