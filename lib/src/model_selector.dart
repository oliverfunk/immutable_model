class ModelSelector<V> {
  final String selectorString;

  List<String> get selectors => selectorString.split('.');

  const ModelSelector(this.selectorString);

  @override
  String toString() => 'ModelSelector: $selectorString';
}
