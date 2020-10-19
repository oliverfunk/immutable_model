import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/model_types.dart';

import '../errors.dart';
import '../exceptions.dart';
import '../model_selector.dart';
import '../model_type.dart';
import '../utils/log.dart';

/// A function that validates [modelMap].
///
/// Note [modelMap] is read-only.
typedef ModelMapValidator = bool Function(Map<String, ModelType> modelMap);

/// A model for a validated map between field label Strings and other [ModelType] models.
///
/// This class is commonly used to define a hierarchical level in an [ImmutableModel].
class ModelInner extends ModelType<ModelInner, Map<String, ModelType>> {
  final BuiltMap<String, ModelType> _current;

  /// The validation function applied to the resulting map after every update.
  final ModelMapValidator modelValidator;

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
  ])  : _current = BuiltMap.of(modelMap),
        super.initial(
          modelMap,
          (_) => true, // this class manages it's own validation
          fieldLabel,
        );

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
  /// If [strictUpdates] is `true`, every update must contain all fields defined in [modelMap]
  /// and every field value cannot be null and must be valid. If it's `false`, updates can
  /// contain a sub-set of the fields and `null` field values will be ignored.
  ///
  /// Throws a [ModelInitialValidationError] if [modelValidator] returns `false` after being run on [modelMap],
  /// during initialization only.
  factory ModelInner(
    Map<String, ModelType> modelMap, {
    ModelMapValidator modelValidator,
    bool strictUpdates = false,
    String fieldLabel,
  }) {
    if (modelMap == null || modelMap.isEmpty) {
      throw ModelInitializationError(
        ModelInner,
        "modelMap cannot be null or empty",
      );
    }
    if (modelValidator != null && !modelValidator(modelMap)) {
      logException(ValidationException(ModelInner, modelMap, fieldLabel));
      throw ModelInitialValidationError(ModelInner, modelMap);
    }
    return ModelInner._(modelMap, modelValidator, strictUpdates, fieldLabel);
  }

  ModelInner._next(ModelInner last, this._current)
      : modelValidator = last.modelValidator,
        strictUpdates = last.strictUpdates,
        super.fromPrevious(last);

  /// Validates [toValidate] using [modelValidator], if it's defined.
  BuiltMap<String, ModelType> _validateModel(
          BuiltMap<String, ModelType> toValidate) =>
      (modelValidator == null || modelValidator(toValidate.asMap()))
          ? toValidate
          : logExceptionAndReturn(
              _current,
              ValidationException(ModelInner, toValidate, fieldLabel),
            );

  /// Checks if [update] complies to the *strict* update rule,
  /// which states:
  /// * Every model in this must be in [update]
  /// * Every model in [update] cannot be the initial instance (see [ModelType.initial])
  /// * Every model in [update] cannot have the same value as the one in this.
  bool _isStrictUpdate(Map<String, ModelType> update) =>
      fieldLabels.every((fl) =>
          update.containsKey(fl) &&
          !update[fl].isInitial &&
          update[fl] != this[fl]);

  @override
  ModelInner buildNext(Map<String, ModelType> updates) {
    if (strictUpdates && !_isStrictUpdate(updates)) {
      return logExceptionAndReturn(this, StrictUpdateException(this, updates));
    }
    if (updates.isEmpty) {
      return this;
    }
    final updated = _current.rebuild((mb) {
      updates.forEach((label, updatedModel) {
        if (hasModel(label)) {
          mb.updateValue(
            label,
            // no new instance is created unless its a value type
            (currentModel) => currentModel.nextFromModel(updatedModel),
          );
        } else {
          throw ModelAccessError(fieldLabels, label);
        }
      });
    });
    return ModelInner._next(
      this,
      _validateModel(updated),
    );
  }

  ModelInner nextWithUpdates(Map<String, dynamic> updates) =>
      next(updates.map<String, ModelType>((label, update) {
        // will throw if the model doesn't exist
        final currentModel = getModel(label);

        // this was once nice and clean
        if (update == null) {
          return MapEntry(label, currentModel);
        } else if (update is ModelType) {
          return MapEntry(label, update);
        } else if (currentModel is ModelInner) {
          if (update is Map<String, dynamic>) {
            return MapEntry(label, currentModel.nextWithUpdates(update));
          } else {
            throw ModelTypeError(this, update);
          }
        } else if (update is ValueUpdater) {
          return MapEntry(label, currentModel.nextFromFunc(update));
        } else {
          return MapEntry(label, currentModel.nextFromDynamic(update));
        }
      }));

  /// Updates the model selected by [selector] with [update].
  ///
  /// Throws a [ModelInnerStrictUpdateError] when [strictUpdates] is enabled.
  ModelInner nextWithSelector<V>(ModelSelector<V> selector, dynamic update) =>
      strictUpdates
          ? throw ModelInnerStrictUpdateError()
          : selector.updateInner(this, update);

  /// The current map between field labels and [ModelType]s.
  ///
  /// Note: this map is unmodifiable (i.e. read-only)
  @override
  Map<String, ModelType> get value => _current.asMap();

  /// The map between field labels and the current [ModelType]s.
  ///
  /// Note: this map is copy-on-write protected.
  /// When modified, a new instance will be created.
  Map<String, ModelType> get modelMap => _current.toMap();

  /// The map between field labels and the current [ModelType] values.
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// Consider instead accessing only the required field values (using the [selectValue] or [get] methods).
  Map<String, dynamic> get valueMap =>
      _current.toMap().map((field, model) => MapEntry(field, model.value));

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
    ModelMapValidator mergedValidator;
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
        mergedValidator =
            (map) => modelValidator(map) && otherModel.modelValidator(map);
      }
    }

    final mergedModelMaps = _current.toMap()
      ..addAll(otherModel._current.toMap());

    return ModelInner._(
        mergedModelMaps, mergedValidator, strictUpdates, fieldLabel);
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

  BuiltMap<String, ModelType> _buildMerge(BuiltMap<String, ModelType> other) =>
      _current.rebuild((mb) {
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
      hasEqualityOfHistory(other)
          ? _buildDelta(other.value)
          : throw ModelHistoryEqualityError(this, other);

  Map<String, dynamic> _buildDelta(Map<String, ModelType> other) {
    final returnMap = <String, dynamic>{};
    other.forEach((otherLabel, otherModel) {
      final thisModel = getModel(otherLabel);

      if (thisModel != otherModel) {
        if (thisModel is ModelInner) {
          // safe to assume otherModel is also ModelInner
          returnMap[otherLabel] =
              thisModel.asSerializableDelta(otherModel as ModelInner);
        } else {
          returnMap[otherLabel] = thisModel.asSerializable();
        }
      }
    });

    return returnMap;
  }

  /// Returns a [Map] between the field labels and the current, serialized model values (using [asSerializable]).
  ///
  /// This method will recurse if a [ModelInner] is present in this model.
  ///
  /// Note: this returns a copy of all components and nested-components of the underlying map,
  /// meaning this could potentially be an expensive call if this model is large.
  /// If this is the case, consider using [asSerializableDelta] on some pre-cached model to serialize only the changes.
  @override
  Map<String, dynamic> asSerializable() =>
      _current.toMap().map((currentField, currentModel) =>
          MapEntry(currentField, currentModel.asSerializable()));

  /// Converts [serialized] into a [Map] of field labels and [ModelType] models.
  ///
  /// [nextFromSerialized] is called on every model
  /// that matches a label in [serialized]
  /// with the serialized value.
  ///
  /// Note: this works deeply with nested maps.
  @override
  Map<String, ModelType> fromSerialized(dynamic serialized) {
    if (serialized is Map<String, dynamic>) {
      // there's possibly a more efficient way of doing this
      final returnMap = <String, ModelType>{};
      serialized.forEach((serLabel, serValue) {
        if (hasModel(serLabel)) {
          returnMap[serLabel] = getModel(serLabel).nextFromSerialized(serValue);
        }
      });
      return returnMap;
    } else {
      return null;
    }
  }

  // field ops

  int get numberOfFields => _current.length;

  Iterable<String> get fieldLabels => _current.keys;

  /// Returns `true` if [label] has an associated model.
  bool hasModel(String label) => _current.containsKey(label);

  /// Returns the [ModelType] model selected by [selector].
  ModelType selectModel<V>(ModelSelector<V> selector) =>
      selector.modelFromInner(this);

  /// Returns the value of the model selected by [selector].
  V selectValue<V>(ModelSelector<V> selector) => selectModel(selector).value;

  /// Returns the [ModelType] model specified by [label].
  ModelType getModel(String label) => hasModel(label)
      ? _current[label]
      : throw ModelAccessError(fieldLabels, label);

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
                  : throw ModelAccessError(fieldLabels, fl);
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
