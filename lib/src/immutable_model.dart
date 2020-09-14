import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'model_selector.dart';
import 'utils/cache_buffer.dart';
import 'errors.dart';
import 'model_type.dart';
import 'model_types/model_inner.dart';

enum ModelState { Default }

@immutable
class ImmutableModel<S> extends Equatable {
  final ModelInner _model;
  final S _state;
  final CacheBuffer<ImmutableModel<S>> _cache;

  ImmutableModel(
    Map<String, ModelType> model, {
    ModelValidator modelValidator,
    S initalState,
    bool strictUpdates = false,
    int cacheBufferSize,
  })  : assert(initalState is S, "The model's initalState must be set"),
        _model = ModelInner(model, modelValidator, strictUpdates),
        _state = initalState ?? ModelState.Default as S,
        _cache = cacheBufferSize == null ? null : CacheBuffer(cacheBufferSize);

  ImmutableModel._nextBoth(ImmutableModel<S> last, this._state, this._model, [bool cacheOrPurge = true])
      : _cache = last._cache {
    if (cacheOrPurge) {
      _cache?.cacheItem(last);
    } else {
      _cache?.purge();
    }
  }

  ImmutableModel._nextModel(ImmutableModel<S> last, this._model, [bool cacheOrPurge = true])
      : _state = last._state,
        _cache = last._cache {
    if (cacheOrPurge) {
      _cache?.cacheItem(last);
    } else {
      _cache?.purge();
    }
  }

  // doens't cache
  ImmutableModel._nextState(ImmutableModel<S> last, this._state)
      : _model = last._model,
        _cache = last._cache;

  // todo
  ImmutableModel<S> restoreBy(int point) => _cache == null ? this : _cache.restoreBy(point);

  // value

  S get currentState => _state;

  /// CoW map
  Map<String, dynamic> toMap() => _model.value;

  // updating

  Map<String, dynamic> _assertNotEmpty(Map<String, dynamic> updateToCheck) =>
      updateToCheck.isNotEmpty ? updateToCheck : throw AssertionError("Update can't be empty");

  ImmutableModel<S> update(Map<String, dynamic> updates) =>
      ImmutableModel<S>._nextModel(this, _model.next(_assertNotEmpty(updates)));

  ImmutableModel<S> updateIfIn(Map<String, dynamic> updates, S inState) =>
      currentState.runtimeType == inState.runtimeType
          ? ImmutableModel<S>._nextModel(this, _model.next(_assertNotEmpty(updates)))
          : throw ModelStateError(currentState, inState);

  ImmutableModel<S> updateWith(Map<String, ValueUpdater> updaters) =>
      ImmutableModel<S>._nextModel(this, _model.next(_assertNotEmpty(updaters)));

  ImmutableModel<S> updateWithModels(Map<String, ModelType> updates) =>
      ImmutableModel<S>._nextModel(this, _model.next(_assertNotEmpty(updates)));

  ImmutableModel<S> updateWithSelector<V>(ModelSelector<V> selector, V value) =>
      ImmutableModel<S>._nextModel(this, _model.nextWithSelector(selector, value));

  ImmutableModel<S> updateWithSelectorIfIn<V>(ModelSelector<V> selector, V value, S inState) =>
      currentState.runtimeType == inState.runtimeType
          ? ImmutableModel<S>._nextModel(this, _model.nextWithSelector(selector, value))
          : throw ModelStateError(currentState, inState);

  ImmutableModel<S> updateTo(ImmutableModel<S> other) =>
      ImmutableModel<S>._nextModel(this, _model.nextFromModel(other._model));

  ImmutableModel<S> mergeFrom(ImmutableModel<S> other) =>
      ImmutableModel<S>._nextModel(this, _model.merge(other._model));

  ImmutableModel<S> resetFields(List<String> fields) => fields.isNotEmpty
      ? ImmutableModel<S>._nextModel(this, _model.resetFields(fields))
      : throw AssertionError("Fields can't be empty");

  ImmutableModel<S> resetAll() => ImmutableModel<S>._nextModel(this, _model.reset(), false);

  ImmutableModel<S> transitionTo(S nextState) => ImmutableModel<S>._nextState(this, nextState);

  ImmutableModel<S> resetAndTransitionTo(S nextState) =>
      ImmutableModel<S>._nextBoth(this, nextState, _model.reset(), false);

  ImmutableModel<S> transitionToAndUpdate(S nextState, Map<String, dynamic> updates) =>
      ImmutableModel<S>._nextBoth(this, nextState, _model.next(_assertNotEmpty(updates)));

  // JSON

  Map<String, dynamic> toJson() => _model.asSerializable();

  Map<String, dynamic> toJsonDiff(ImmutableModel<S> other) => _model.toJsonDiff(other._model);

  // more lient for json
  ImmutableModel<S> fromJson(Map<String, dynamic> jsonMap) =>
      ImmutableModel<S>._nextModel(this, _model.fromJson(jsonMap));

  // field ops

  Iterable<String> get fields => _model.fieldLabels;

  int get numberOfFields => _model.numberOfFields;

  bool hasField(String field) => _model.hasField(field);

  ModelType<dynamic, V> selectModel<V>(ModelSelector<V> selector) => _model.selectModel(selector);

  V select<V>(ModelSelector<V> selector) => _model.select(selector);

  ModelType fieldModel(String field) => _model.fieldModel(field);

  dynamic fieldValue(String field) => _model.fieldValue(field);

  dynamic operator [](String field) => _model[field];

  // misc

  /// Resets the initalModel to the newly joined one
  ImmutableModel<S> join(
    ImmutableModel otherModel, [
    bool strictUpdates = false,
    String fieldLabel,
  ]) =>
      ImmutableModel<S>._nextModel(this, _model.join(otherModel._model, strictUpdates));

  @override
  List<Object> get props => [_state, _model];

  @override
  String toString() => "<${currentState.runtimeType}>${_model.toString()}";
}
