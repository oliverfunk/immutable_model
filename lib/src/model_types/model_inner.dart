import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/model_selector.dart';

import '../../model_types.dart';
import '../model_type.dart';

import '../utils/log.dart';
import '../exceptions.dart';
import '../errors.dart';

/// note [modelMap] is unmodifable
typedef bool ModelValidator(Map<String, dynamic> modelMap);

class ModelInner extends ModelType<ModelInner, Map<String, dynamic>> {
  final BuiltMap<String, ModelType> _current;
  final ModelValidator modelValidator;
  final bool strictUpdates;

  ModelInner(
    Map<String, ModelType> modelMap, [
    this.modelValidator,
    this.strictUpdates = false,
    String fieldLabel,
  ])  : assert(modelMap != null && modelMap.isNotEmpty, "The model cannot be null and must have fields"),
        _current = BuiltMap.of(modelMap),
        super.inital(
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

  BuiltMap<String, ModelType> _validateModel(BuiltMap<String, ModelType> toValidate) =>
      (modelValidator == null || modelValidator(toValidate.asMap()))
          ? toValidate
          : logExceptionAndReturn(_current, ValidationException(this, toValidate));

  ModelInner _builder(
    BuiltMap<String, ModelType> Function(Map<String, dynamic> update) mapBuilder,
    Map<String, dynamic> update,
  ) =>
      (strictUpdates && !checkUpdateStrictly(update))
          ? logExceptionAndReturn(this, StrictUpdateException(this, update))
          : update.isEmpty ? this : ModelInner._next(this, _validateModel(mapBuilder(update)));

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

  ModelInner nextWithSelector<V>(ModelSelector<V> selector, V value) =>
      next(_mapifySelectors(selector.selectors, value));

  Map<String, dynamic> _mapifySelectors(Iterable<String> list, dynamic value) =>
      list.length == 1 ? {list.first: value} : {list.first: _mapifySelectors(list.skip(1), value)};

  /*
  * Checks if every field in the model is in the update and has a value.
  */
  bool checkUpdateStrictly(Map<String, dynamic> update) =>
      fieldLabels.every((field) => update.containsKey(field) && update[field] != null);

  // not efficient
  @override
  Map<String, dynamic> get value => _current.toMap().map((field, model) => MapEntry(field, model.value));

  Map<String, ModelType> get asModelMap => _current.asMap();

  ModelInner merge(ModelInner other) => hasEqualityOfHistory(other)
      ? ModelInner._next(this, _buildMerge(other._current))
      : throw ModelHistoryEqualityError(this, other);

  BuiltMap<String, ModelType> _buildMerge(BuiltMap<String, ModelType> other) => _current.rebuild((mb) {
        other.forEach((otherField, otherModel) {
          mb.updateValue(
              otherField,
              (currentModel) => currentModel is ModelInner
                  ? currentModel.merge(otherModel)
                  : otherModel.isInitial ? currentModel : otherModel);
        });
      });

  Map<String, dynamic> toJsonDiff(ModelInner other) =>
      hasEqualityOfHistory(other) ? _buildToJsonDiff(other._current) : throw ModelHistoryEqualityError(this, other);

  Map<String, dynamic> _buildToJsonDiff(BuiltMap<String, ModelType> other) => Map.unmodifiable(_current
      .toMap()
      .map<String, dynamic>((currentField, currentModel) => currentModel == other[currentField]
          ? MapEntry(currentField, null)
          : currentModel is ModelInner
              ? MapEntry(currentField, currentModel.toJsonDiff(other[currentField] as ModelInner))
              : MapEntry(currentField, currentModel.asSerializable()))
        ..removeWhere((field, model) => model == null));

  /// Join two models together. Values from other will over-wrtie values in this
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

  // not efficient, use sparingly retured map is unmodifable, if you want moidifabl euse value
  @override
  Map<String, dynamic> asSerializable() => Map.unmodifiable(
      _current.toMap().map((currentField, currentModel) => MapEntry(currentField, currentModel.asSerializable())));

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
  Iterable<String> get fieldLabels => _current.keys;

  bool hasField(String field) => _current.containsKey(field);

  int get numberOfFields => _current.length;

  ModelType _select(Iterable<String> selectorStrings) {
    final fm = fieldModel(selectorStrings.first);
    if (selectorStrings.length == 1) {
      return fm;
    } else {
      return fm is ModelInner ? fm._select(selectorStrings.skip(1)) : throw ModelSelectError(selectorStrings.first);
    }
  }

  // R useSelector<R>(SelectorString<R> sel) => select(sel.selectorString) as R;

  ModelType<dynamic, V> selectModel<V>(ModelSelector<V> selector) =>
      _select(selector.selectors) as ModelType<dynamic, V>;

  V select<V>(ModelSelector<V> selector) => selectModel(selector).value;

  ModelType fieldModel(String field) => hasField(field) ? _current[field] : throw ModelAccessError(this, field);

  dynamic fieldValue(String field) => fieldModel(field).value;

  dynamic operator [](String field) {
    final fm = fieldModel(field);
    return fm is ModelInner ? fm : fm.value;
  }

  ModelInner resetFields(List<String> fields) => isInitial
      ? this
      : ModelInner._next(this, _current.rebuild((mb) {
          fields.forEach((field) {
            hasField(field)
                ? mb.updateValue(field, (currentModel) => currentModel.inital)
                : throw ModelAccessError(this, field);
          });
        }));

  ModelInner reset() => inital;

  @override
  List<Object> get props => [_current];

  @override
  String toString() => _current.toString();
}
