import 'package:immutable_model/src/immutable_entities/immutable_list.dart';
import 'package:immutable_model/src/model_entities/model_child.dart';

import '../model_entity.dart';

typedef V ListItemDeserializer<V>(dynamic item);
typedef dynamic ListItemSerializer<V>(V item);

class ModelList<V> extends ImmutableList<V> with ModelEntity<List<V>> {
  final ListItemDeserializer<V> listItemDeserializer;
  final ListItemSerializer<V> listItemSerializer;

  ModelList(this.listItemSerializer, this.listItemDeserializer,
      [List<V> defaultList, ListItemValidator<V> listItemValidator, bool append = true])
      : super(defaultList, listItemValidator, append);

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
  List<V> deserialize(update) => update is List<dynamic> ? _toTypedList(update) : throw Exception('not list');

  @override
  List<dynamic> asSerializable() => asList(listItemSerializer);
}

class ModelPrimitiveList<V> extends ModelList<V> {
  ModelPrimitiveList([List<V> defaultList, ListItemValidator<V> listItemValidator, bool append = true])
      : super((li) => li, (si) => si is V ? si : throw Exception('Cannt convert'), defaultList, listItemValidator,
            append);
}

class ModelCompositeList extends ModelList<ModelChild> {
  ModelCompositeList(ModelChild listItemModel, [bool append = true])
      : super((mc) => mc.asSerializable(), (smc) => listItemModel.updateWith(smc), null, null, append);
}
