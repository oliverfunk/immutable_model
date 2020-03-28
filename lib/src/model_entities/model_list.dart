import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/model_entity.dart';

import 'model.dart';

typedef V ListItemDeserializer<V>(dynamic item);
typedef dynamic ListItemSerializer<V>(V item);
typedef void ListItemValidator<V>(V item);

class ModelList<V> extends ModelEntity<ModelList<V>, List<V>> {
  final ListItemValidator<V> listItemValidator;
  final bool append;

  final BuiltList<V> _list;
  final BuiltList<V> _defaultList;

  final ListItemSerializer<V> listItemSerializer;
  final ListItemDeserializer<V> listItemDeserializer;

  ModelList._(ModelList<V> instance, this._list)
      : listItemValidator = instance.listItemValidator,
        append = instance.append,
        _defaultList = instance._defaultList,
        listItemSerializer = instance.listItemSerializer,
        listItemDeserializer = instance.listItemDeserializer;

  ModelList(this.listItemSerializer, this.listItemDeserializer,
      [List<V> defaultList, this.listItemValidator, this.append = true])
      : _list = null,
        _defaultList = BuiltList.of(defaultList ?? <V>[]) {
    validate(defaultList);
  }

  BuiltList<V> _safeListInstance() => (_list ?? _defaultList);

  List<V> _safeValidateListItems(List<V> listToValidate) => (listItemValidator != null && listToValidate != null)
      ? (listToValidate..forEach((item) => listItemValidator(item)))
      : listToValidate;

  List<V> _toTypedList(List<dynamic> listToConvert) =>
      listToConvert is List<V> ? listToConvert : listToConvert.map((li) => _safeDeserializeListItem(li));

  V _safeDeserializeListItem(dynamic listItem) {
    try {
      return listItemDeserializer(listItem);
    } catch (e) {
      throw Exception("couldn't deserialize $listItem into type $V");
    }
  }

  @override
  List<V> get value => _safeListInstance().toList();

  @override
  List<V> validate(List<V> listToValidate) => _safeValidateListItems(listToValidate);

  @override
  ModelList<V> build(List<V> nextList) => ModelList._(
      this,
      nextList == null
          ? null
          : _safeListInstance().rebuild((lb) => append ? lb.addAll(nextList) : lb.replace(nextList)));

  @override
  List<V> deserialize(update) => update is List<dynamic> ? _toTypedList(update) : throw Exception('not list');

  @override
  List<dynamic> asSerializable() => _safeListInstance().map((item) => listItemSerializer(item)).toList();
}

class ModelPrimitiveList<V> extends ModelList<V> {
  ModelPrimitiveList([List<V> defaultList, ListItemValidator<V> listItemValidator, bool append = true])
      : super((li) => li, (si) => si is V ? si : throw Exception('Cannt convert'), defaultList, listItemValidator,
            append);
}

class ModelCompositeList extends ModelList<Map<String, dynamic>> {
  ModelCompositeList(Model listItemModel, [bool append = true])
      : super((mc) => mc, (smc) => smc is Map<String, dynamic> ? smc : throw ("Provided is not a map"), null,
            (mapToValidate) {
          listItemModel.updateWith(mapToValidate);
          // if that doesn't throw any errors
          return mapToValidate;
        }, append);
}
