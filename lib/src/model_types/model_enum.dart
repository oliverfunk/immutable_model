import 'package:valid/valid.dart';

import '../model_type.dart';

class ModelEnum<E> extends ValidEnumType<ModelEnum<E>, E>
    with ModelType<ModelEnum<E>, E> {
  final String _fieldLabel;

  ModelEnum(
    E initialEnum, {
    required List<E> enumValues,
    required String fieldLabel,
  })   : _fieldLabel = fieldLabel,
        super.initial(
          initialEnum,
          enumValues: enumValues,
        );

  ModelEnum._next(ModelEnum<E> previous, E nextEnum)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextEnum);

  @override
  ModelEnum<E> buildNext(E nextEnum) => ModelEnum._next(this, nextEnum);

  @override
  String get label => _fieldLabel;

  @override
  String serializer(E currentEnum) => asString();

  @override
  E? deserializer(dynamic jsonValue) =>
      jsonValue is String ? fromString<E>(enums, jsonValue) : null;
}
