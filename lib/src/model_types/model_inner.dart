import 'package:built_collection/built_collection.dart';

import '../errors.dart';
import '../exceptions.dart';
import '../model_selector.dart';
import '../model_type.dart';
import '../utils/log.dart';

/// A function that validates [modelMap].
///
/// Note [modelMap] is read-only
typedef ModelValidator = bool Function(Map<String, ModelType> modelMap);

/// A model for a validated map between field label Strings and other [ModelType] models.
///
/// This class is commonly used to define a hierarchical level in an [ImmutableModel].
class ModelInner extends ModelType<ModelInner, Map<String, dynamic>> {
  final BuiltMap<String, ModelType> _current;

  /// The validation function applied to the resulting map after every update.
  final ModelValidator modelValidator;

  /// Controls whether updates are applied strictly or not.
  ///
  /// If `true`, every update must contain all the fields defined for this [ModelInner] and every field must have a value.
  /// If `false`, updates can contain a sub-set of the defined fields.
  final bool strictUpdates;

  ModelInner._(
    Map<String, ModelType> modelMap, [
    this.modelValidator,
    this.strictUpdates = false,
    String fieldLabel,
  ])  : assert(modelMap != null && modelMap.isNotEmpty, "The model cannot be null or empty"),
        _current = BuiltMap.of(modelMap),
        super.initial(
          modelMap,
          (_) => true, // this class manages it's own validation
          fieldLabel,
        ) {
    if (modelValidator != null && !modelValidator(modelMap)) {
      logException(ValidationException(this, value));
      throw ModelInitializationError(this, value);
    }
  }

  /// Constructs a [ModelType] of map between field label [String]s and other [ModelType] models.
  ///
  /// [modelMap] cannot be null or empty.
  ///
  /// [modelValidator] is a function that must return `true` if the underlying map of this class passed to it is valid
  /// and `false` otherwise. [modelValidator] can be `null` indicating this model has no validation.
  ///
  /// [modelValidator] will be run on the resulting (new) map after every update ([next] etc.) applied to this model.
  /// If it returns `true`, the update will be applied. Otherwise a [ValidationException]
  /// will be logged as a *WARNING* message (instead of being thrown) and the current instance returned
  /// (without the updated applied).
  ///
  /// If [strictUpdates] is true, every update must contain all fields defined in [modelMap]
  /// and every field value cannot be null and must be valid. If it's false, updates can
  /// contain a sub-set of the fields.
  ///
  /// Throws a [ModelInitializationError] if [modelValidator] returns `false` after being run on [modelMap],
  /// during initialization only.
  factory ModelInner(
    Map<String, ModelType> modelMap, {
    ModelValidator modelValidator,
    bool strictUpdates = false,
    String fieldLabel,
  }) =>
      ModelInner._(modelMap, modelValidator, strictUpdates, fieldLabel);

  ModelInner._next(ModelInner last, this._current)
      : modelValidator = last.modelValidator,
        strictUpdates = last.strictUpdates,
        super.fromPrevious(last);

  /// Validates [toValidate] using [modelValidator], if it's defined.
  BuiltMap<String, ModelType> _validateModel(BuiltMap<String, ModelType> toValidate) =>
      (modelValidator == null || modelValidator(toValidate.asMap()))
          ? toValidate
          : logExceptionAndReturn(_current, ValidationException(this, toValidate));

  ModelInner _builder(
    BuiltMap<String, ModelType> Function(Map<String, dynamic> update) mapBuilder,
    Map<String, dynamic> update,
  ) =>
      (strictUpdates && !_checkUpdateStrictly(update))
          ? logExceptionAndReturn(this, StrictUpdateException(this, update))
          : update.isEmpty
              ? this
              : ModelInner._next(this, _validateModel(mapBuilder(update)));

  BuiltMap<String, ModelType> _buildNext(Map<String, dynamic> next) => _current.rebuild((mb) {
        next.forEach((field, nextValue) {
          hasModel(field)
              ? mb.updateValue(
                  field,
                  (currentModel) => nextValue == null
                      ? currentModel.next(null)
                      : nextValue is ModelType // model update
                          ? currentModel.nextFromModel(nextValue)
                          : nextValue is ValueUpdater // function update
                              ? currentModel.nextFromFunc(nextValue)
                              : currentModel.nextFromDynamic(nextValue)) // normal value update
              : throw ModelAccessError(this, field);
        });
      });

  @override
  ModelInner buildNext(Map<String, dynamic> next) => _builder(_buildNext, next);

  /// Updates the field selected by [selector] with [update] and returns the new instance.
  ModelInner nextWithSelector<V>(ModelSelector<V> selector, dynamic update) =>
      next(_mapifySelectors(selector.selectors, update));

  Map<String, dynamic> _mapifySelectors(Iterable<String> list, dynamic value) =>
      list.length == 1 ? {list.first: value} : {list.first: _mapifySelectors(list.skip(1), value)};

  /// Checks if every field in the model is in [update] and has a value.
  ///
  /// Returns `true` if [update] is strict, `false` otherwise.
  bool _checkUpdateStrictly(Map<String, dynamic> update) =>
      fieldLabels.every((fl) => update.containsKey(fl) && update[fl] != null);

  /// Checks [update] as if were used to update this [ModelInner].
  ///
  /// Returns `true` if [update] would be valid, `false` otherwise.
  bool checkUpdate(Map<String, dynamic> update) {
    if (strictUpdates && !_checkUpdateStrictly(update)) {
      return false;
    }
    for (var fl in update.keys) {
      if (!hasModel(fl)) {
        return false;
      }
    }

    return true;
  }

  /// The map between field labels and the current [ModelType] values.
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// Consider instead accessing only the required field values (using the [selectValue] or [get] methods).
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, model) => MapEntry(field, model.value));

  /// The map between field labels and the current [ModelType]s.
  ///
  /// Note: this map is unmodifiable (i.e. read-only)
  Map<String, ModelType> get asModelMap => _current.asMap();

  /// Joins [otherModel] to this and creates a new [ModelInner] from the result.
  ///
  /// Models in this will be replaced by those in [otherModel] if they share the same field label.
  ///
  /// Both models [modelValidator] functions are AND'd together, if they exist.
  ModelInner join(
    ModelInner otherModel, {
    bool strictUpdates = false,
    String fieldLabel,
  }) {
    // merge the two validators
    ModelValidator mergedValidator;
    if (modelValidator == null) {
      if (otherModel.modelValidator == null) {
        // both null
        mergedValidator = null;
      } else {
        // only other not null
        mergedValidator = otherModel.modelValidator;
      }
    } else {
      if (otherModel.modelValidator == null) {
        // only this not null
        mergedValidator = modelValidator;
      } else {
        // both not null
        mergedValidator = (map) => modelValidator(map) && otherModel.modelValidator(map);
      }
    }

    final mergedModelMaps = _current.toMap()..addAll(otherModel._current.toMap());

    return ModelInner._(mergedModelMaps, mergedValidator, strictUpdates, fieldLabel);
  }

  /// Merges [other] into this and returns the new next instance.
  ///
  /// The models in this are replaced by the corresponding ones in [other].
  /// However, any model in [other] that [isInitial] will be skipped and not merged.
  ///
  /// Note: this merges deeply (i.e. applies recursively to nested [ModelInner]s).
  ModelInner merge(ModelInner other) => hasEqualityOfHistory(other)
      ? ModelInner._next(this, _buildMerge(other._current))
      : throw ModelHistoryEqualityError(this, other);

  BuiltMap<String, ModelType> _buildMerge(BuiltMap<String, ModelType> other) => _current.rebuild((mb) {
        other.forEach((otherField, otherModel) {
          mb.updateValue(
              otherField,
              (currentModel) => currentModel is ModelInner
                  ? currentModel.merge(otherModel)
                  : otherModel.isInitial
                      ? currentModel
                      : otherModel);
        });
      });

  /// Returns a [Map] between the field labels and the current, serialized model values,
  /// based on the delta from [other] to this.
  ///
  /// If the corresponding models are equal, they are removed from the resulting map.
  /// Otherwise, the model value in this is serialized (using [asSerializable]).
  ///
  /// To avoid unexpected results, this should share a *direct* history with [other].
  ///
  /// This is useful if, for example, you want to serialize only the changes to a model to send to a remote.
  ///
  /// Note: this works deeply with nested [ModelInner]s.
  Map<String, dynamic> asSerializableDelta(ModelInner other) =>
      hasEqualityOfHistory(other) ? _buildDelta(other._current) : throw ModelHistoryEqualityError(this, other);

  Map<String, dynamic> _buildDelta(BuiltMap<String, ModelType> other) =>
      _current.toMap().map((currentField, currentModel) => currentModel == other[currentField]
          ? MapEntry(currentField, null)
          : currentModel is ModelInner
              ? MapEntry(currentField, currentModel.asSerializableDelta(other[currentField] as ModelInner))
              : MapEntry(currentField, currentModel.asSerializable()))
        ..removeWhere((field, model) => model == null);

  /// Returns a [Map] between the field labels and the current, serialized model values (using [asSerializable]).
  ///
  /// This method will recurse if a [ModelInner] is present in this model.
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// If this is the case, consider using [asSerializableDelta] on some pre-cached model to serialize only the changes.
  @override
  Map<String, dynamic> asSerializable() =>
      _current.toMap().map((currentField, currentModel) => MapEntry(currentField, currentModel.asSerializable()));

  /// Converts [serialized] into a [Map] of [String]s and deserialized values.
  ///
  /// The values are deserialized using the [fromSerialized] method on the corresponding model in this [ModelInner].
  /// If the model doesn't exist, the entry is removed.
  ///
  /// Note: this works deeply with nested maps.
  @override
  Map<String, dynamic> fromSerialized(dynamic serialized) => serialized is! Map<String, dynamic>
      ? null
      : serialized.map((serField, serValue) => hasModel(serField)
          ? MapEntry(serField, getModel(serField).fromSerialized(serValue))
          : MapEntry(serField, null))
    ..removeWhere((field, value) => value == null);

  // field ops

  int get numberOfFields => _current.length;

  Iterable<String> get fieldLabels => _current.keys;

  /// Returns `true` if [label] has an associated model.
  bool hasModel(String label) => _current.containsKey(label);

  ModelType _select(Iterable<String> selectorStrings) {
    final fm = getModel(selectorStrings.first);
    if (selectorStrings.length == 1) {
      return fm;
    } else {
      return fm is ModelInner ? fm._select(selectorStrings.skip(1)) : throw ModelSelectError(selectorStrings.first);
    }
  }

  /// Returns the [ModelType] model selected by [selector].
  ModelType<dynamic, V> selectModel<V>(ModelSelector<V> selector) =>
      _select(selector.selectors) as ModelType<dynamic, V>;

  /// Returns the value of the model selected by [selector].
  V selectValue<V>(ModelSelector<V> selector) => selectModel(selector).value;

  /// Returns the [ModelType] model specified by [label].
  ModelType getModel(String label) => hasModel(label) ? _current[label] : throw ModelAccessError(this, label);

  /// Returns the value of the model specified by [label].
  dynamic get(String label) => getModel(label).value;

  /// Returns the value of the model specified by [label], except if the model is a [ModelInner], in which case
  /// the [ModelInner] model will be returned, not its value.
  dynamic operator [](String label) {
    final fm = getModel(label);
    return fm is ModelInner ? fm : fm.value;
  }

  /// Resets the models specified by [fieldLabels] to their [initial] instance.
  ModelInner resetFields(List<String> fieldLabels) => isInitial
      ? this
      : ModelInner._next(
          this,
          _current.rebuild((mb) {
            for (var fl in fieldLabels) {
              hasModel(fl)
                  ? mb.updateValue(fl, (currentModel) => currentModel.initial)
                  : throw ModelAccessError(this, fl);
            }
          }),
        );

  /// Resets all models to their [initial] instance.
  ModelInner resetAll() => initial;

  @override
  List<Object> get props => [_current];

  @override
  String toString() => _current.toString();
}
