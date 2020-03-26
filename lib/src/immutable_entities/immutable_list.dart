import 'package:built_collection/built_collection.dart';

import '../immutable_entity.dart';

typedef void ListItemValidator<V>(V item);

class ImmutableList<V> extends ImmutableEntity<List<V>> {
  final ListItemValidator<V> listItemValidator;
  final bool append;

  final BuiltList<V> _list;
  final BuiltList<V> _defaultList;

  // constructors
  ImmutableList._(ImmutableList instance, this._list)
      : _defaultList = instance._defaultList,
        append = instance.append,
        listItemValidator = instance.listItemValidator;

  ImmutableList([List<V> defaultList, this.listItemValidator, this.append = true])
      : _list = null,
        _defaultList = BuiltList.of(defaultList ?? <V>[]) {
    validate(defaultList);
  }

  // private helper class methods
  BuiltList<V> _safeListInstance() => (_list ?? _defaultList);

  List<V> _safeValidateListItems(List<V> listToValidate) => (listItemValidator != null && listToValidate != null)
      ? (listToValidate..forEach((item) => listItemValidator(item)))
      : listToValidate;

  // immutable entity methods
  @override
  List<V> get value => _safeListInstance().toList();

  @override
  List<V> validate(List<V> listToValidate) => _safeValidateListItems(listToValidate);

  @override
  ImmutableEntity<List<V>> build(List<V> nextList) => ImmutableList._(
      this,
      nextList == null
          ? null
          : _safeListInstance().rebuild((lb) => append ? lb.addAll(nextList) : lb.replace(nextList)));

  // class methods
  List<dynamic> asList(dynamic Function(V) itemSerializer) =>
      _safeListInstance().map((item) => itemSerializer(item)).toList();
}
