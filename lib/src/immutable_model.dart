import 'package:equatable/equatable.dart';

import 'buffer.dart';
import 'model_types/model_inner.dart';
import 'model_value.dart';

enum ModelState { Default }

class ImmutableModel<S> extends Equatable {
  final ModelInner _model;
  final S _state;
  final CacheBuffer<ImmutableModel<S>> _cache;

  ImmutableModel(
    Map<String, ModelValue> model, {
    ModelValidator modelValidator,
    S initalState,
    bool strictUpdates = false,
    int cacheBufferSize = 0,
  })  : _model = ModelInner(model, modelValidator, strictUpdates),
        _state = initalState ?? ModelState.Default as S,
        _cache = CacheBuffer(cacheBufferSize);

  ImmutableModel._nextBoth(ImmutableModel<S> last, this._state, this._model) : _cache = last._cache {
    _cache.cacheItem(last);
  }

  ImmutableModel._nextModel(ImmutableModel<S> last, this._model)
      : _state = last._state,
        _cache = last._cache {
    _cache.cacheItem(last);
  }

  // doens't cache
  ImmutableModel._nextState(ImmutableModel<S> last, this._state)
      : _model = last._model,
        _cache = last._cache;

  ImmutableModel<S> restoreTo(int point) => _cache.restoreTo(point);

  // value

  S get currentState => _state;

  /// CoW map
  Map<String, dynamic> asMap() => _model.value;

  // updating

  ImmutableModel<S> update(Map<String, dynamic> updates) =>
      (updates == null || updates.isEmpty) ? this : ImmutableModel<S>._nextModel(this, _model.next(updates));

  ImmutableModel<S> updateWith(Map<String, ValueUpdater> updaters) =>
      (updaters == null || updaters.isEmpty) ? this : ImmutableModel<S>._nextModel(this, _model.next(updaters));

  ImmutableModel<S> updateWithModels(Map<String, ModelValue> updates) =>
      (updates == null || updates.isEmpty) ? this : ImmutableModel<S>._nextModel(this, _model.next(updates));

  ImmutableModel<S> updateFrom(ImmutableModel<S> other) =>
      other == null ? this : ImmutableModel<S>._nextModel(this, _model.nextFromModel(other._model));

  ImmutableModel<S> mergeFrom(ImmutableModel<S> other) =>
      other == null ? this : ImmutableModel<S>._nextModel(this, _model.merge(other._model));

  ImmutableModel<S> resetFields(List<String> fields) =>
      (fields == null || fields.isEmpty) ? this : ImmutableModel<S>._nextModel(this, _model.resetFields(fields));

  ImmutableModel<S> resetAll() => ImmutableModel<S>._nextModel(this, _model.resetAll());

  ImmutableModel<S> transitionTo(S nextState) =>
      nextState == null ? this : ImmutableModel<S>._nextState(this, nextState);

  ImmutableModel<S> transitionToWithUpdate(S nextState, Map<String, dynamic> updates) =>
      (nextState == null) && (updates == null || updates.isEmpty)
          ? this
          : ImmutableModel<S>._nextBoth(this, nextState, _model.next(updates));

  // JSON

  Map<String, dynamic> toJson() => _model.asSerializable();

  ImmutableModel<S> fromJson(Map<String, dynamic> jsonMap) =>
      (jsonMap == null || jsonMap.isEmpty) ? this : ImmutableModel<S>._nextModel(this, _model.fromJson(jsonMap));

  // field ops

  Iterable<String> get fields => _model.fields;

  int get numberOfFields => _model.numberOfFields;

  bool hasField(String field) => _model.hasField(field);

  ModelValue getFieldModel(String field) => _model.getFieldModel(field);

  dynamic getFieldValue(String field) => _model.getFieldValue(field);

  dynamic operator [](String field) => getFieldValue(field);

  // misc

  @override
  List<Object> get props => [_state, _model];

  @override
  String toString() => "<${currentState.runtimeType}>${_model.toString()}";
}
