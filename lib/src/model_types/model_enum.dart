import 'package:valid/valid.dart';

import '../serializable_valid_type.dart';

class ModelEnum<E> extends ValidEnumType<ModelEnum<E>, E>
    with SerializableValidType<ModelEnum<E>, E> {
  final String _fieldLabel;

  ModelEnum(
    this._fieldLabel,
    List<E> enumValues,
    E initialEnum,
  ) : super.initial(enumValues, initialEnum);

  ModelEnum._next(ModelEnum<E> previous, E nextEnum)
      : _fieldLabel = previous._fieldLabel,
        super.constructNext(previous, nextEnum);

  @override
  ModelEnum<E> buildNext(E nextEnum) => ModelEnum._next(this, nextEnum);

  @override
  String get fieldLabel => _fieldLabel;

  @override
  String serializer(E currentEnum) => asString();

  @override
  E? deserializer(dynamic jsonValue) =>
      jsonValue is String ? fromString<E>(enums, jsonValue) : null;

  // @override
  // String toString() => "ModelEnum<$E>($value)";
}
