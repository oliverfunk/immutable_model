import 'package:built_collection/built_collection.dart';

import '../model_type.dart';
import '../model_selector.dart';

import '../utils/log.dart';
import '../exceptions.dart';
import '../errors.dart';

/// A function that validates [modelMap].
///
/// Note [modelMap] is read-only
typedef bool ModelValidator(Map<String, ModelType> modelMap);

/// A model for a validated map between field label Strings and other [ModelType] models.
///
/// This class is commonly used to define a hierarchical level in an [ImmutableModel].
class ModelInner extends ModelType<ModelInner, Map<String, dynamic>> {
  final BuiltMap<String, ModelType> _current;

  /// The validation function applied to the resulting map after every update.
  final ModelValidator modelValidator;

  /// Controls whether updates are applied strictly or not.
  ///
  /// If true, every update must contain all the fields defined for this [ModelInner] and every field must have a value.
  /// If false, updates can contain a sub-set of the fields defined for this [ModelInner].
  final bool strictUpdates;

  /// Constructs a [ModelInner].
  ///
  /// [modelMap] defines a mapping between field label Strings and [ModelType] models. It cannot be null or empty.
  ///
  /// Each time this [ModelInner] is updated, the [modelValidator] function is run on the resulting map
  /// (with the updated values). If the validation fails, a [ValidationException] will be logged
  /// and the current instance will be returned, without having the update applied.
  ///
  /// If [strictUpdates] is true, every update must contain all fields defined in [modelMap]
  /// and every field value cannot be null and must be valid. If it's false, updates can
  /// contain a sub-set of the fields.
  ///
  /// Throws a [ModelInitializationError] if [modelValidator] is false after being run on [modelMap],
  /// during initialization only.
  ModelInner(
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

  ModelInner._next(ModelInner last, this._current)
      : modelValidator = last.modelValidator,
        strictUpdates = last.strictUpdates,
        super.fromPrevious(last);

  /// Validate [toValidate] using [modelValidator], if it's defined.
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
          hasField(field)
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

  /// Updates the field selected by [selector] with [value] and returns the new instance.
  ModelInner nextWithSelector<V>(ModelSelector<V> selector, V value) =>
      next(_mapifySelectors(selector.selectors, value));

  Map<String, dynamic> _mapifySelectors(Iterable<String> list, dynamic value) =>
      list.length == 1 ? {list.first: value} : {list.first: _mapifySelectors(list.skip(1), value)};

  /// Checks if every field in the model is in [update] and has a value.
  ///
  /// Returns `true` if [update] is strict otherwise `false`.
  bool _checkUpdateStrictly(Map<String, dynamic> update) =>
      fieldLabels.every((field) => update.containsKey(field) && update[field] != null);

  /// Checks [update] as if were used to update this [ModelInner].
  ///
  /// Returns `true` if [update] would be valid, `false` otherwise.
  bool checkUpdate(Map<String, dynamic> update) {
    if (strictUpdates && !_checkUpdateStrictly(update)) {
      return false;
    }
    update.keys.forEach((fLabel) {
      if (!hasField(fLabel)) {
        return false;
      }
    });
    return true;
  }

  @override
  Map<String, dynamic> get value => _current.toMap().map((field, model) => MapEntry(field, model.value));

  /// Returns an unmodifiable map of the field labels and [ModelType]s
  Map<String, ModelType> get asModelMap => _current.asMap();

  /// Merges [other] into this and returns the new instance.
  ///
  /// The models in this are replaced by the corresponding ones in [other].
  /// However, any model in [other] that [isInitial] will be skipped and not merged.
  ///
  /// This is a deep merge (i.e. it applies recursively to any [ModelInner]s present).
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

  /// Returns a [Map] of field labels and serialized model values based on the diff between this and [other].
  ///
  /// If the model in this and the corresponding one in [other] are the same, it will be removed from the resulting [Map].
  ///
  /// This is useful if, for example, you want to send the changes to a model to a remote server.
  Map<String, dynamic> toJsonDiff(ModelInner other) =>
      hasEqualityOfHistory(other) ? _buildToJsonDiff(other._current) : throw ModelHistoryEqualityError(this, other);

  Map<String, dynamic> _buildToJsonDiff(BuiltMap<String, ModelType> other) => Map.unmodifiable(
      _current.toMap().map<String, dynamic>((currentField, currentModel) => currentModel == other[currentField]
          ? MapEntry(currentField, null)
          : currentModel is ModelInner
              ? MapEntry(currentField, currentModel.toJsonDiff(other[currentField] as ModelInner))
              : MapEntry(currentField, currentModel.asSerializable()))
        ..removeWhere((field, model) => model == null));

  /// Joins [other] to this and creates a new [ModelInner] from the result.
  ///
  /// Models in this will be replaced by those in [other] if they share the same field label.
  ///
  /// The model's [modelValidator] functions are AND'd together, if they exist.
  ModelInner join(
    ModelInner other, [
    bool strictUpdates = false,
    String fieldLabel,
  ]) {
    // merge the two validators
    ModelValidator mergedValidator;
    if (modelValidator == null) {
      if (other.modelValidator == null) {
        // both null
        mergedValidator = null;
      } else {
        // only other not null
        mergedValidator = other.modelValidator;
      }
    } else {
      if (other.modelValidator == null) {
        // only this not null
        mergedValidator = modelValidator;
      } else {
        // both not null
        mergedValidator = (map) => modelValidator(map) && other.modelValidator(map);
      }
    }

    final mergedModelMaps = _current.toMap()..addAll(other._current.toMap());

    return ModelInner(mergedModelMaps, mergedValidator, strictUpdates, fieldLabel);
  }

  /// Returns a [Map] of field labels and serialized model values
  ///
  /// The model values are serialized by calling [asSerializable] on each one
  /// and will therefore recursive if a [ModelInner] is present.
  ///
  /// This map is read-only (unmodifiable).
  @override
  Map<String, dynamic> asSerializable() => Map.unmodifiable(
      _current.toMap().map((currentField, currentModel) => MapEntry(currentField, currentModel.asSerializable())));

  /// Updates the current instance with the values from [jsonMap]
  /// by calling [nextFromSerialized] on the corresponding model.
  ModelInner fromJson(Map<String, dynamic> jsonMap) =>
      jsonMap.isEmpty ? this : _builder((jsonMap) => _buildFromJson(fromSerialized(jsonMap)), jsonMap);

  BuiltMap<String, ModelType> _buildFromJson(Map<String, dynamic> jsonMap) => _current.rebuild((mb) {
        jsonMap.forEach((jsonField, jsonValue) {
          // skip fields not in model
          if (hasField(jsonField)) {
            mb.updateValue(
                jsonField,
                (currentModel) => jsonValue == null || jsonValue == '' // skip nulls and empty strings
                    ? currentModel
                    : currentModel is ModelInner
                        ? currentModel.fromJson(fromSerialized(jsonValue))
                        : currentModel.nextFromSerialized(jsonValue));
          }
        });
      });

  // field ops

  int get numberOfFields => _current.length;

  Iterable<String> get fieldLabels => _current.keys;

  bool hasField(String fieldLabel) => _current.containsKey(fieldLabel);

  ModelType _select(Iterable<String> selectorStrings) {
    final fm = fieldModel(selectorStrings.first);
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
  V select<V>(ModelSelector<V> selector) => selectModel(selector).value;

  /// Returns the [ModelType] model specified by [field].
  ModelType fieldModel(String field) => hasField(field) ? _current[field] : throw ModelAccessError(this, field);

  /// Returns the value of the model specified by [field].
  dynamic fieldValue(String field) => fieldModel(field).value;

  /// Returns the value of the model specified by [field], except if the model is a [ModelInner], in which case
  /// the [ModelInner] will be returned and not its value.
  dynamic operator [](String field) {
    final fm = fieldModel(field);
    return fm is ModelInner ? fm : fm.value;
  }

  /// Resets the models specified by [fields] to their [initial] instance.
  ModelInner resetFields(List<String> fields) => isInitial
      ? this
      : ModelInner._next(this, _current.rebuild((mb) {
          fields.forEach((field) {
            hasField(field)
                ? mb.updateValue(field, (currentModel) => currentModel.initial)
                : throw ModelAccessError(this, field);
          });
        }));

  /// Resets all models to their [initial] instance.
  ModelInner reset() => initial;

  @override
  List<Object> get props => [_current];

  @override
  String toString() => _current.toString();
}
