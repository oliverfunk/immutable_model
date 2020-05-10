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

  BuiltList<V> _safeInstance() => _initialList ?? _currentList;

  @override
  ModelList<V> build(List<V> updates) => updates == null
      ? ModelList._(this, _initialList)
      : ModelList._(this, _safeInstance().rebuild((lb) => _append ? lb.addAll(updates) : lb.replace(updates)));

  @override
  List<V> get value => _safeInstance().toList();

  @override
  List<V> validate(List<V> listToValidate) =>
      (listToValidate == null || _listItemValidator == null) ? listToValidate : listToValidate
        ..forEach((item) => _listItemValidator(item));

  @override
  List<Object> get props => [_safeInstance()];

// TODO: impl Remove(idx, or list of idx's) Replace(idx, data)
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(ImmutableModel model, [List<Map<String, dynamic>> initialList, bool append = true])
      : super(initialList, (li) => model.update(li), append);
}
