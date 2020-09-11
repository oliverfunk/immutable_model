import 'package:built_collection/built_collection.dart';

import '../utils/log.dart';
import '../exceptions.dart';

import '../model_type.dart';
import 'model_inner.dart';

typedef bool ListItemValidator<V>(V item);

class ModelList<V> extends ModelType<ModelList<V>, List<V>> {
  final BuiltList<V> _current;
  final bool _append;

  // constructors

  ModelList.boolList([
    List<bool> initialList,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<bool>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          null,
          fieldLabel,
        );

  ModelList.intList([
    List<int> initialList,
    ListItemValidator<int> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<int>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          itemValidator == null ? null : (List toValidate) => toValidate.every((element) => itemValidator(element)),
          fieldLabel,
        );

  ModelList.doubleList([
    List<double> initialList,
    ListItemValidator<double> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<double>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          itemValidator == null ? null : (List toValidate) => toValidate.every((element) => itemValidator(element)),
          fieldLabel,
        );

  ModelList.stringList([
    List<String> initialList,
    ListItemValidator<String> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<String>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          itemValidator == null ? null : (List toValidate) => toValidate.every((element) => itemValidator(element)),
          fieldLabel,
        );

  ModelList.dateTimeList([
    List<DateTime> initialList,
    ListItemValidator<DateTime> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<DateTime>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          itemValidator == null ? null : (List toValidate) => toValidate.every((element) => itemValidator(element)),
          fieldLabel,
        );

  ModelList._mapList([
    List<Map<String, dynamic>> initialList,
    ListItemValidator<Map<String, dynamic>> itemValidator,
    bool append = true,
    String fieldLabel,
  ])  : _current = BuiltList<Map<String, dynamic>>.of(initialList) as BuiltList<V>,
        _append = append,
        super.inital(
          initialList as List<V>,
          itemValidator == null ? null : (List toValidate) => toValidate.every((element) => itemValidator(element)),
          fieldLabel,
        );

  ModelList._next(ModelList<V> last, this._current)
      : _append = last._append,
        super.fromPrevious(last);

// ModelPrimitive._next(ModelPrimitive<T> last, this._current) : super.fromLast(last);

  @override
  ModelList<V> buildNext(List<V> next) =>
      ModelList._next(this, _current.rebuild((lb) => _append ? lb.addAll(next) : lb.replace(next)));

  // public methods

  @override
  List<V> get value => _current.toList();

  List<V> get asNoneMut => _current.asList();

  @override
  @override
  dynamic asSerializable() => V == DateTime ? (value.map((dt) => (dt as DateTime).toIso8601String())) : value;

  @override
  List<V> fromSerialized(dynamic serialized) => serialized is List
      ? V == DateTime
          ? serialized.cast<String>().map((dtStr) => DateTime.parse(dtStr)) as List<V>
          : serialized.cast<V>()
      : null;

  ModelList<V> removeAt(int index) => ModelList._next(this, _current.rebuild((lb) => lb.removeAt(index)));

  ModelList<V> replaceAt(int index, V item) => ModelList._next(this, _current.rebuild((lb) {
        if (validate([item])) {
          lb[index] = item;
        } else {
          logException(ValidationException(this, item));
        }
      }));

  ModelList<V> clear() => ModelList._next(this, _current.rebuild((lb) => lb.clear()));

  V getElementAt(int index) => _current.elementAt(index);

  V operator [](int index) => getElementAt(index);

  @override
  List<Object> get props => [_current];
}

class ModelValidatedList extends ModelList<Map<String, dynamic>> {
  ModelValidatedList(
    ModelInner model, [
    List<Map<String, dynamic>> initialList,
    bool append = true,
  ]) : super._mapList(initialList, (li) => _validateItemAgainstModel(model, li), append);

  static bool _validateItemAgainstModel(ModelInner model, Map<String, dynamic> update) =>
      model.checkUpdateStrictly(update);
}
