import '../immutable_model.dart';
import '../model_types.dart';
import 'errors.dart';

/// A class used to select a model in an [ImmutableModel] or [ModelInner],
/// where [V] is the model's value type.
///
/// See [ImmutableModel.updateWithSelector] and [ModelInner.selectValue].
///
/// Note: this class is `const`.
class ModelSelector<V> {
  /// The dot string query selector.
  final String selectorString;

  const ModelSelector(this.selectorString);

  /// The [selectorString] but spilt into array elements on each `.`.
  List<String> get _selectors => selectorString.split('.');

  Map<String, dynamic> _mapifySelectors(Iterable<String> list, dynamic value) =>
      list.length == 1
          ? {list.first: value}
          : {list.first: _mapifySelectors(list.skip(1), value)};

  ModelType _select(
    Map<String, ModelType> modelMap,
    Iterable<String> selectorStrings,
  ) {
    final selectedField = selectorStrings.first;
    final selectedModel = modelMap.containsKey(selectedField)
        ? modelMap[selectedField]
        : throw ModelAccessError(modelMap.keys, selectedField);
    if (selectorStrings.length == 1) {
      return selectedModel;
    } else {
      return selectedModel is ModelInner
          ? _select(selectedModel.asModelMap, selectorStrings.skip(1))
          : throw ModelSelectError(selectorStrings.first);
    }
  }

  /// Returns the selected [ModelType] model from [modelMap].
  ModelType modelFromModelMap(Map<String, ModelType> modelMap) =>
      _select(modelMap, _selectors);

  /// Returns the selected [ModelType.value] from [modelMap].
  V valueFromModelMap(Map<String, ModelType> modelMap) =>
      modelFromModelMap(modelMap).value;

  /// Returns the selected [ModelType] model from [inner].
  ModelType modelFromInner(ModelInner inner) =>
      modelFromModelMap(inner.asModelMap);

  /// Returns the selected [ModelType.value] from [inner].
  V valueFromInner(ModelInner inner) => valueFromModelMap(inner.asModelMap);

  /// Returns the selected [ModelType] model from [im].
  ModelType modelFromImmutableModel(ImmutableModel im) =>
      modelFromInner(im.inner);

  /// Returns the selected [ModelType.value] from [im].
  V valueFromImmutableModel(ImmutableModel im) => valueFromInner(im.inner);

  /// Updates the model selected by [selector] in [inner] with [update].
  ModelInner updateInner(ModelInner inner, dynamic update) =>
      inner.next(_mapifySelectors(_selectors, update));

  @override
  String toString() => 'ModelSelector: $selectorString';
}
