import '../exceptions.dart';
import 'model_value.dart';

typedef bool DateTimeChecker(DateTime date);

class ModelDateTime extends ModelValue<ModelDateTime, DateTime> {
  final ModelDateTime _initialModel;

  final DateTime _current;
  final DateTimeChecker _checker;
  final String _fieldName;

  ModelDateTime([DateTime initial, DateTimeChecker checker, String fieldName])
      : _initialModel = null,
        _current = initial,
        _checker = checker,
        _fieldName = fieldName {
    if (_current != null) validate(_current);
  }

  ModelDateTime._next(ModelDateTime last, this._current)
      : _initialModel = last.initialModel,
        _checker = last._checker,
        _fieldName = last._fieldName;

  @override
  ModelDateTime build(DateTime next) => ModelDateTime._next(this, next);

  @override
  ModelDateTime get initialModel => _initialModel ?? this;

  // methods

  @override
  DateTime get value => _current;

  @override
  DateTime validate(DateTime toValidate) => _checker == null
      ? toValidate
      : _checker(toValidate) ? toValidate : throw ModelValidationException(this, toValidate);

  @override
  String asSerializable() => value.toIso8601String();

  @override
  DateTime deserializer(dynamic jsonValue) => jsonValue is String
      ? DateTime.parse(jsonValue)
      : throw ModelFromJsonException(this, jsonValue);

  @override
  String get modelFieldName => _fieldName;
}
