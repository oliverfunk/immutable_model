import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../model_type.dart';

class ModelEnum<E> extends ValidEnumType<ModelEnum<E>, E>
    with ModelType<ModelEnum<E>, E> {
  final String _label;

  ModelEnum(
    E initialEnum, {
    required List<E> enumValues,
    required String label,
  })   : _label = label,
        super.initial(
          initialEnum,
          enumValues: enumValues,
        );

  ModelEnum._next(ModelEnum<E> previous, E nextEnum)
      : _label = previous._label,
        super.constructNext(previous, nextEnum);

  @override
  @protected
  ModelEnum<E> buildNext(E nextEnum) => ModelEnum._next(this, nextEnum);

  @override
  String get label => _label;

  @override
  String serializer(E currentEnum) => asString();

  @override
  E? deserializer(dynamic jsonValue) =>
      jsonValue is String ? fromString<E>(enums, jsonValue) : null;
}
