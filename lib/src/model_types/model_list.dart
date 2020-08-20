import 'package:built_collection/built_collection.dart';

import '../exceptions.dart';
import '../immutable_model.dart';
import '../model_value.dart';

typedef bool ListItemValidator<V>(V item);

class ModelList<V> extends ModelValue<ModelList<V>, List<V>> {
  final ModelList<V> _initialModel;

  final BuiltList<V> _current;
  final ListItemValidator<V> _itemValidator;
  final bool _append;

  final String _fieldLabel;

  // constructors

  ModelList.boolList([
    List<bool> initialList,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<bool>.of(initialList) as BuiltList<V>,
        _itemValidator = null,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList.intList([
    List<int> initialList,
    ListItemValidator<int> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<int>.of(initialList) as BuiltList<V>,
        _itemValidator = itemValidator as ListItemValidator<V>,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList.doubleList([
    List<double> initialList,
    ListItemValidator<double> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<double>.of(initialList) as BuiltList<V>,
        _itemValidator = itemValidator as ListItemValidator<V>,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList.stringList([
    List<String> initialList,
    ListItemValidator<String> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<String>.of(initialList) as BuiltList<V>,
        _itemValidator = itemValidator as ListItemValidator<V>,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList.dateTimeList([
    List<DateTime> initialList,
    ListItemValidator<DateTime> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<DateTime>.of(initialList) as BuiltList<V>,
        _itemValidator = itemValidator as ListItemValidator<V>,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList._mapList([
    List<Map<String, dynamic>> initialList,
    ListItemValidator<Map<String, dynamic>> listItemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _initialModel = null,
        _current = BuiltList<Map<String, dynamic>>.of(initialList) as BuiltList<V>,
        _itemValidator = listItemValidator as ListItemValidator<V>,
        _append = append,
        _fieldLabel = fieldLabel;

  ModelList._next(ModelList<V> last, this._current)
      : _initialModel = last.initialModel,
        _itemValidator = last._itemValidator,
        _append = last._append,
        _fieldLabel = last._fieldLabel;

  @override
  ModelList<V> build(List<V> next) =>
      ModelList._next(this, _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  // public methods

  @override
  List<V> get value => _current.toList();

  @override
  ModelList<V> get initialModel => _initialModel ?? this;

  @override
  bool checkValid(List<V> toValidate) => (toValidate.isEmpty ||
      _itemValidator == null ||
      toValidate.every((element) => _itemValidator(element))); // check every item in the list against the validator

  @override
  V whichInvalid(List<V> invalid) => invalid.firstWhere((li) => !_itemValidator(li));

  @override
  dynamic asSerializable() => V == DateTime ? (value.map((dt) => (dt as DateTime).toIso8601String())) : value;

  @override
  ModelList<V> deserialize(dynamic serialized) {
    if (serialized is List) {
      return V == DateTime
          ? next(serialized.cast<String>().map((dtStr) => DateTime.parse(dtStr)) as List<V>)
          : next(serialized.cast<V>());
    } else {
      throw ImmutableModelDeserialisationException(this, serialized);
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
  String get fieldLabel => _fieldLabel;
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(
    ImmutableModel model, [
    List<Map<String, dynamic>> initialList,
    bool append = true,
  ]) : super._mapList(initialList, (li) => _validateItemAgainstModel(model, li), append);

  static bool _validateItemAgainstModel(ImmutableModel model, Map<String, dynamic> item) {
    model.update(item);
    // if strict update completes, it's valid
    return true;
  }

  @override
  ModelList<Map<String, dynamic>> replaceAt(int index, Map<String, dynamic> element) =>
      ModelList._next(this, _current.rebuild((lb) => lb[index] = validate([element])[0]));
}
