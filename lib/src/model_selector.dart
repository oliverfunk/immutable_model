/// A selector class used to select a model in an [ImmutableModel] or [ModelInner].
///
/// See [ImmutableModel.updateWithSelector] and [ModelInner.selectValue].
///
/// Note: this class in `const`.
class ModelSelector<V> {
  /// The dot string query selector.
  final String selectorString;

  /// The [selectorString] but spilt into array elements.
  List<String> get selectors => selectorString.split('.');

  const ModelSelector(this.selectorString);

  @override
  String toString() => 'ModelSelector: $selectorString';
}
