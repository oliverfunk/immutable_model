import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'errors.dart';
import 'model_selector.dart';
import 'model_type.dart';
import 'model_types/model_inner.dart';
import 'utils/cache_buffer.dart';

/// Default placeholder state for [ImmutableModel]'s
// ignore: constant_identifier_names
enum ModelState { Default }

/// The main class used to define immutable state models.
@immutable
class ImmutableModel<S> extends Equatable {
  /// The internal [ModelInner] used by this class.
  final ModelInner _model;

  /// The underlying [ModelInner].
  ModelInner get inner => _model;

  /// The model's current state.
  final S _state;

  /// An internal buffer cache for undo changes done to the model.
  ///
  /// Note: this is isn't stable and it's current implementation can have unintended consequences.
  final CacheBuffer<ImmutableModel<S>> _cache;

  /// Constructs a class used to define an immutable state model.
  ///
  /// [modelMap] is  a map between field label [String]s and other [ModelType] models, which defines the model's scheme
  /// and the field validations.
  /// [modelMap] cannot be null or empty.
  ///
  /// [modelValidator] is a function that must return `true` if the map passed to it from an update is valid,
  /// `false` otherwise. [modelValidator] can be `null` indicating no map level validations are required.
  ///
  /// If during an update, [modelValidator] returns `false` a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [strictUpdates] is true, every update must contain all fields defined in [modelMap]
  /// and every field value cannot be null and must be valid. If it's false, updates can
  /// contain a sub-set of the fields.
  ///
  /// Throws a [ModelInitialValidationError] if [modelValidator] returns `false` after being run on [modelMap],
  /// during initialization only.
  ImmutableModel(
    Map<String, ModelType> modelMap, {
    ModelMapValidator modelValidator,
    S initialState,
    bool strictUpdates = false,
    int cacheBufferSize,
  })  : assert(initialState is S, "The model's initialState must be set"),
        _model = ModelInner(
          modelMap,
          modelValidator: modelValidator,
          strictUpdates: strictUpdates,
        ),
        _state = initialState ?? ModelState.Default as S,
        _cache = cacheBufferSize == null ? null : CacheBuffer(cacheBufferSize);

  /// Construct the next instance using both a state and model change.
  ///
  /// If [cacheOrPurge] is `true`, [last] is added to the end of the cache.
  /// Otherwise the cache is purged, all items are removed.
  ImmutableModel._nextBoth(ImmutableModel<S> last, this._state, this._model,
      [bool cacheOrPurge = true])
      : _cache = last._cache {
    if (cacheOrPurge) {
      _cache?.cacheItem(last);
    } else {
      _cache?.purge();
    }
  }

  /// Construct the next instance using only a model change.
  ///
  /// If [cacheOrPurge] is `true`, [last] is added to the end of the cache.
  /// Otherwise the cache is purged, all items are removed.
  ImmutableModel._nextModel(ImmutableModel<S> last, this._model,
      [bool cacheOrPurge = true])
      : _state = last._state,
        _cache = last._cache {
    if (cacheOrPurge) {
      _cache?.cacheItem(last);
    } else {
      _cache?.purge();
    }
  }

  /// Construct the next instance using only a state change.
  ///
  /// If [cacheOrPurge] is `true`, [last] is added to the end of the cache.
  /// Otherwise the cache is purged, all items are removed.
  ImmutableModel._nextState(ImmutableModel<S> last, this._state,
      [bool cacheOrPurge = true])
      : _model = last._model,
        _cache = last._cache {
    if (cacheOrPurge) {
      _cache?.cacheItem(last);
    } else {
      _cache?.purge();
    }
  }

  /// Returns the [ImmutableModel] instance from the number of [point]s before.
  ///
  /// if `point=1`, the previous instance would be returned (like an undo).
  ///
  /// Note: this feature is still experimental and unexpected results can occur.
  @experimental
  ImmutableModel<S> restoreBy(int point) =>
      _cache == null ? this : _cache.restoreBy(point);

  // value

  /// The current state
  S get currentState => _state;

  /// The map between field labels and the current [ModelType] values.
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// Consider instead accessing only the required field values (using the [select] or [get] methods).
  Map<String, dynamic> toMap() => _model.value;

  // updating

  Map<String, dynamic> _assertNotEmpty(Map<String, dynamic> updateToCheck) =>
      updateToCheck.isNotEmpty
          ? updateToCheck
          : throw AssertionError("Update can't be empty");

  /// Updates the current model values with those specified in [updates].
  ///
  /// The field label strings in [updates] must exist in this [ImmutableModel].
  ///
  /// The values in [updates] can be a value, a [ValueUpdater] function or a [ModelType].
  ImmutableModel<S> update(Map<String, dynamic> updates) =>
      ImmutableModel<S>._nextModel(this, _model.next(_assertNotEmpty(updates)));

  ImmutableModel<S> updateIfIn(Map<String, dynamic> updates, S inState) =>
      currentState.runtimeType == inState.runtimeType
          ? update(updates)
          : throw ModelStateError(currentState, inState);

  /// As [update] but the values must be [ValueUpdater] functions
  ImmutableModel<S> updateWith(Map<String, ValueUpdater> updaters) =>
      update(updaters);

  /// As [update] but the values must be [ModelType]s.
  ImmutableModel<S> updateWithModels(Map<String, ModelType> updates) =>
      update(updates);

  /// Updates the field selected by [selector] with [update].
  ///
  /// [update] can be a value, a [ValueUpdater] function or a [ModelType].
  ImmutableModel<S> updateWithSelector<V>(
          ModelSelector<V> selector, dynamic update) =>
      ImmutableModel<S>._nextModel(
          this, _model.nextWithSelector(selector, update));

  /// Updates the field selected by [selector] with [update] if [currentState] is [inState].
  ///
  /// [update] can be a value, a [ValueUpdater] function or a [ModelType].
  ImmutableModel<S> updateWithSelectorIfIn<V>(
          ModelSelector<V> selector, V update, S inState) =>
      currentState.runtimeType == inState.runtimeType
          ? updateWithSelector<V>(selector, update)
          : throw ModelStateError(currentState, inState);

  /// All models are set to those in [other],
  /// only if the underlying [ModelInner] in this [ImmutableModel] share a history with the one in [other].
  ImmutableModel<S> updateTo(ImmutableModel<S> other) =>
      ImmutableModel<S>._nextModel(this, _model.nextFromModel(other._model));

  /// Merges [other] into this.
  ///
  /// As [ModelInner.merge].
  ImmutableModel<S> mergeFrom(ImmutableModel<S> other) =>
      ImmutableModel<S>._nextModel(this, _model.merge(other._model));

  /// Resets the models specified by [fieldLabels] to their [ModelType.initial] instance.
  ///
  /// [fieldLabels] cannot be empty.
  ImmutableModel<S> resetFields(List<String> fieldLabels) =>
      fieldLabels.isNotEmpty
          ? ImmutableModel<S>._nextModel(this, _model.resetFields(fieldLabels))
          : throw AssertionError("Fields can't be empty");

  /// Resets all the models in this to their [ModelType.initial] instance.
  ImmutableModel<S> resetAll() =>
      ImmutableModel<S>._nextModel(this, _model.resetAll(), false);

  /// Sets the [currentState] to [nextState].
  ImmutableModel<S> transitionTo(S nextState) =>
      ImmutableModel<S>._nextState(this, nextState);

  /// Resets all the models in this to their [ModelType.initial] instance and sets the [currentState] to [nextState].
  ImmutableModel<S> resetAndTransitionTo(S nextState) =>
      ImmutableModel<S>._nextBoth(this, nextState, _model.resetAll(), false);

  /// Sets the [currentState] to [nextState] and updates the models values specified by [updates].
  ImmutableModel<S> transitionToAndUpdate(
          S nextState, Map<String, dynamic> updates) =>
      ImmutableModel<S>._nextBoth(
          this, nextState, _model.next(_assertNotEmpty(updates)));

  // JSON

  /// Returns a [Map] between the field labels and the current, serialized model values (using [ModelType.asSerializable]).
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// If this is the case, consider using [toJsonDiff] on a previous instance of this [ImmutableModel].
  Map<String, dynamic> toJson() => _model.asSerializable();

  /// Returns a [Map] between the field labels and the current, serialized model values,
  /// based on the delta from [other] to this.
  ///
  /// If the corresponding models are equal, they are removed from the resulting map.
  /// Otherwise, the model value in this is serialized (using [ModelType.asSerializable]).
  ///
  /// To avoid unexpected results, this should share a *direct* history with [other].
  ///
  /// This is useful if, for example, you want to serialize only the changes to a model to send to a remote.
  Map<String, dynamic> toJsonDiff(ImmutableModel<S> other) =>
      _model.asSerializableDelta(other._model);

  /// Deserializes the values in [jsonMap] and updates the current model values with them.
  ///
  /// The values are deserialized using the corresponding model [ModelType.fromSerialized] method.
  ImmutableModel<S> fromJson(Map<String, dynamic> jsonMap) =>
      ImmutableModel<S>._nextModel(this, _model.nextFromSerialized(jsonMap));

  // field ops

  Iterable<String> get fieldLabels => _model.fieldLabels;

  int get numberOfFields => _model.numberOfFields;

  bool hasModel(String fieldLabel) => _model.hasModel(fieldLabel);

  /// Returns the [ModelType] model selected by [selector].
  ModelType<dynamic, V> selectModel<V>(ModelSelector<V> selector) =>
      _model.selectModel(selector);

  /// Returns the value of the model selected by [selector].
  V select<V>(ModelSelector<V> selector) => _model.selectValue(selector);

  /// Returns the [ModelType] model specified by [fieldLabel].
  ModelType getModel(String fieldLabel) => _model.getModel(fieldLabel);

  /// Returns the value of the model specified by [fieldLabel].
  dynamic get(String fieldLabel) => _model.get(fieldLabel);

  /// Returns the value of the model specified by [fieldLabel], except if the model is a [ModelInner], in which case
  /// the [ModelInner] model will be returned, not its value.
  dynamic operator [](String fieldLabel) => _model[fieldLabel];

  // misc

  /// Joins [other] to this and creates a new [ImmutableModel] from the result.
  ///
  /// Models in this will be replaced by those in [other] if they share the same field label.
  ///
  /// [strictUpdates] sets the value for the newly joined instance.
  ///
  /// The [currentState] of this is set as initial state for the joined instance.
  ///
  /// The cache buffer size of this is set as the cache buffer size for the joined instance.
  ImmutableModel<S> join(
    ImmutableModel other, {
    bool strictUpdates = false,
  }) {
    final joinedInner = _model.join(other._model, strictUpdates: strictUpdates);
    return ImmutableModel<S>(
      joinedInner.asModelMap,
      modelValidator: joinedInner.modelValidator,
      initialState: _state,
      strictUpdates: strictUpdates,
      cacheBufferSize: _cache.bufferSize,
    );
  }

  @override
  List<Object> get props => [_state, _model];

  @override
  String toString() => "<${currentState.runtimeType}>${_model.toString()}";
}
