import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/v2/immutable_entities/immutable_entity.dart';
import 'package:immutable_model/src/v2/immutable_entities/model_entity.dart';

typedef void ListItemValidator<V>(V item);

class ImmutableList<V> extends ModelEntity<List<V>> {
  // private class members
  final BuiltList<V> _list;
  final BuiltList<V> _defaultList;

  // public class members
  final bool append;
  final ListItemValidator<V> listItemValidator;

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

  List<V> _toTypedList(List<dynamic> l) => l is List<V> ? l : l.map((li) => _safeDeserializeListItem(li));

  V _safeDeserializeListItem(dynamic item) {
    try {
      return itemDeserializer(item);
    } catch (e) {
      throw Exception("couldn't deserialize $item into type $V");
    }
  }

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

  // model entity methods
  @override
  List<V> deserialize(update) => update is List<dynamic> ? update : throw Exception('not list');

  // class methods

}
