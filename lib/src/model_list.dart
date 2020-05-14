import 'package:built_collection/built_collection.dart';
import 'package:immutable_model/src/immutable_model.dart';
import 'package:immutable_model/src/model_value.dart';

typedef void ListItemValidator<V>(V item);

class ModelList<V> extends ModelValue<ModelList<V>, List<V>> {
  final BuiltList<V> _currentList;
  final BuiltList<V> _initialList;
  final bool _append;
  final ListItemValidator<V> _listItemValidator;

  ModelList._(ModelList<V> last, this._currentList)
      : _initialList = last._initialList,
        _listItemValidator = last._listItemValidator,
        _append = last._append;

  ModelList([List<V> initialList, ListItemValidator<V> listItemValidator, bool append = true])
      : _currentList = null,
        _initialList = BuiltList.of(initialList),
        _listItemValidator = listItemValidator,
        _append = append {
    validate(initialList);
  }

  BuiltList<V> _safeInstance() => _currentList ?? _initialList;

  @override
  ModelList<V> build(List<V> updates) => updates == null
      ? ModelList._(this, _initialList)
      : ModelList._(this, _safeInstance().rebuild((lb) => _append ? lb.addAll(updates) : lb.replace(updates)));

  @override
  List<V> get value => _safeInstance().toList();

  @override
  List<V> validate(List<V> listToValidate) {
    if (listToValidate == null || listToValidate.isEmpty || _listItemValidator == null) {
      return listToValidate;
    } else {
      return listToValidate..forEach((item) => _listItemValidator(item));
    }
  }

  ModelList<V> remove(int index) => ModelList._(this, _safeInstance().rebuild((lb) => lb.removeAt(index)));

  ModelList<V> replace(int index, V element) => ModelList._(this, _safeInstance().rebuild((lb) => lb[index] = element));

  V getElementAt(int index) => _safeInstance().elementAt(index);

  V operator [](int index) => getElementAt(index);

  @override
  List<Object> get props => [_safeInstance()];

// must return void
//  ModelList<V> operator []=(int index, V element) => replace(index, element);
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(ImmutableModel model, [List<Map<String, dynamic>> initialList, bool append = true])
      : super(initialList, (li) => model.update(li), append);

  @override
  ModelList<Map<String, dynamic>> replace(int index, Map<String, dynamic> element) =>
      ModelList._(this, _safeInstance().rebuild((lb) => lb[index] = validate([element])[0]));
}
