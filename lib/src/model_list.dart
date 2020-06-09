import 'package:built_collection/built_collection.dart';

import 'exceptions.dart';
import 'immutable_model.dart';
import 'model_value.dart';

typedef bool ListItemValidator<V>(V item);

class ModelList<V> extends ModelValue<ModelList<V>, List<V>> {
  final ModelList<V> _initial;

  final BuiltList<V> _current;
  final bool _append;
  final ListItemValidator<V> _listItemValidator;

  ModelList._(ModelList<V> last, this._current)
      : _initial = last.initialModel,
        _listItemValidator = last._listItemValidator,
        _append = last._append;

  ModelList([List<V> initialList, ListItemValidator<V> listItemValidator, bool append = true])
      : _initial = null,
        _current = BuiltList.of(initialList),
        _listItemValidator = listItemValidator,
        _append = append {
    if (initialList != null && !initialList.isEmpty) validate(initialList);
  }

  @override
  List<V> get value => _current.toList();

  @override
  ModelList<V> get initialModel => _initial ?? this;

  @override
  List<V> validate(List<V> toValidate) => toValidate.isEmpty || _listItemValidator == null ? toValidate : toValidate
    ..forEach((item) => _listItemValidator(item) ? item : throw ModelValidationException(item, modelFieldName));

  @override
  ModelList<V> build(List<V> next) =>
      ModelList._(this, _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  ModelList<V> remove(int index) => ModelList._(this, _current.rebuild((lb) => lb.removeAt(index)));

  ModelList<V> replace(int index, V element) => ModelList._(this, _current.rebuild((lb) => lb[index] = element));

  ModelList<V> clear() => ModelList._(this, _current.rebuild((lb) => lb.clear()));

  V getElementAt(int index) => _current.elementAt(index);

  V operator [](int index) => getElementAt(index);

  @override
  List<Object> get props => [_current];

// []= must return void, so can't use it...
//  ModelList<V> operator []=(int index, V element) => replace(index, element);
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(ImmutableModel model,
      [List<Map<String, dynamic>> initialList, bool append = true, bool withCompleteUpdates = true])
      : super(initialList, (li) => _validateItemAgainstModel(model, withCompleteUpdates, li), append);

  static bool _validateItemAgainstModel(ImmutableModel model, bool withCompleteUpdates, Map<String, dynamic> item) {
    if (withCompleteUpdates) {
      model.strictUpdate(item);
      return true;
    } else {
      model.update(item);
      return true;
    }
  }

  @override
  ModelList<Map<String, dynamic>> replace(int index, Map<String, dynamic> element) =>
      ModelList._(this, _current.rebuild((lb) => lb[index] = validate([element])[0]));
}
