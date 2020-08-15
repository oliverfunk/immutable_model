import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../immutable_model.dart';
import '../model_value.dart';

//TODO: all the type casts, necc?
// validate method

typedef bool ListItemValidator<V>(V item);

class ModelList<V> extends ModelValue<ModelList<V>, List<V>> {
  final ModelList<V> _initialModel;

  final BuiltList<V> _current;
  final ListItemValidator<V> _listItemValidator;
  final bool _append;

  final String _fieldName;

  // constructors

  ModelList.boolList([List<bool> initialList, bool append = true, String fieldName])
      : _initialModel = null,
        _current = BuiltList<bool>.of(initialList) as BuiltList<V>,
        _listItemValidator = null,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList.intList(
      [List<int> initialList, ListItemValidator<int> listItemValidator, bool append = true, String fieldName])
      : _initialModel = null,
        _current = BuiltList<int>.of(initialList) as BuiltList<V>,
        _listItemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList.doubleList(
      [List<double> initialList, ListItemValidator<double> listItemValidator, bool append = true, String fieldName])
      : _initialModel = null,
        _current = BuiltList<double>.of(initialList) as BuiltList<V>,
        _listItemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList.stringList(
      [List<String> initialList, ListItemValidator<String> listItemValidator, bool append = true, String fieldName])
      : _initialModel = null,
        _current = BuiltList<String>.of(initialList) as BuiltList<V>,
        _listItemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList.dateTimeList(
      [List<DateTime> initialList, ListItemValidator<DateTime> listItemValidator, bool append = true, String fieldName])
      : _initialModel = null,
        _current = BuiltList<DateTime>.of(initialList) as BuiltList<V>,
        _listItemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList._mapList(
      [List<Map<String, dynamic>> initialList,
      ListItemValidator<Map<String, dynamic>> listItemValidator,
      bool append = true,
      String fieldName])
      : _initialModel = null,
        _current = BuiltList<Map<String, dynamic>>.of(initialList) as BuiltList<V>,
        _listItemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldName = fieldName {
    if (_current != null && _current.isNotEmpty) validate(_current.asList());
  }

  ModelList._next(ModelList<V> last, this._current)
      : _initialModel = last.initialModel,
        _listItemValidator = last._listItemValidator,
        _append = last._append,
        _fieldName = last._fieldName;

  @override
  ModelList<V> build(List<V> next) =>
      ModelList._next(this, _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  // public methods

  @override
  List<V> get value => _current.toList();

  @override
  ModelList<V> get initialModel => _initialModel ?? this;

  @override
  bool isValid(List<V> toValidate) => (toValidate.isEmpty ||
      _listItemValidator == null ||
      toValidate.every((element) => _listItemValidator(element))); // check every item in the list against the validator

  @override
  V whichInvalid(List<V> invalid) => invalid.firstWhere((li) => !_listItemValidator(li));

  @override
  dynamic asSerializable() => V == DateTime ? (value.map((dt) => (dt as DateTime).toIso8601String())) : value;

  @override
  List<V> deserialize(dynamic jsonValue) {
    if (jsonValue is List) {
      if (V == DateTime) {
        return jsonValue.cast<String>().map((dtStr) => DateTime.parse(dtStr)) as List<V>;
      } else {
        return jsonValue.cast<V>();
      }
    } else {
      throw ModelFromJsonException(this, jsonValue);
    }
  }

  ModelList<V> removeAt(int index) => ModelList._next(this, _current.rebuild((lb) => lb.removeAt(index)));

  ModelList<V> replaceAt(int index, V element) => ModelList._next(this, _current.rebuild((lb) => lb[index] = element));

  ModelList<V> clear() => ModelList._next(this, _current.rebuild((lb) => lb.clear()));

  V getElementAt(int index) => _current.elementAt(index);

  V operator [](int index) => getElementAt(index);

// []= must return void, so can't use it...
//  ModelList<V> operator []=(int index, V element) => replace(index, element);

  @override
  List<Object> get props => [_current];

  @override
  String get modelFieldName => _fieldName;
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(ImmutableModel model, [List<Map<String, dynamic>> initialList, bool append = true])
      : super._mapList(initialList, (li) => _validateItemAgainstModel(model, li), append);

  static bool _validateItemAgainstModel(ImmutableModel model, Map<String, dynamic> item) {
    model.strictUpdate(item);
    // if strict update completes, it's valid
    return true;
  }

  @override
  ModelList<Map<String, dynamic>> replaceAt(int index, Map<String, dynamic> element) =>
      ModelList._next(this, _current.rebuild((lb) => lb[index] = validate([element])[0]));
}
