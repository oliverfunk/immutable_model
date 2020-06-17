import '../exceptions.dart';
import 'model_value.dart';

class ModelEnum<E> extends ModelValue<ModelEnum<E>, String> {
  final ModelEnum _initialModel;

  final String _current;
  final List<String> _enums;
  final String _fieldName;

  // constructors

  ModelEnum.fromStringList(List<String> enums, String initial,
      [String fieldName])
      : _initialModel = null,
        _current = initial,
        _enums = enums,
        _fieldName = fieldName;

  ModelEnum._next(ModelEnum last, this._current)
      : _initialModel = last.initialModel,
        _enums = last._enums,
        _fieldName = last._fieldName;

  // static methods

  static List<String> fromEnumList<E>(List<E> enumValues) =>
      enumValues.map((en) => fromEnum(en)).toList();

  static String fromEnum<E>(E enumValue) => enumValue.toString().split('.')[1];

  // methods

  @override
  String get value => _current;

  @override
  ModelEnum<E> get initialModel => _initialModel ?? this;

  @override
  String validate(String toValidate) => _enums.contains(toValidate)
      ? toValidate
      : throw ModelValidationException(this, toValidate);

  @override
  ModelEnum<E> build(String nextEnum) => ModelEnum._next(this, nextEnum);

  @override
  String get modelFieldName => _fieldName;

  @override
  String toString() => "<$E as String>($value)";
}
