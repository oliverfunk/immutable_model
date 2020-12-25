import 'package:immutable_model/src/errors.dart';
import 'package:immutable_model/src/immutable_model/field_update.dart';
import 'package:immutable_model/src/immutable_model/immutable_model.dart';

import '../model_type.dart';

class ModelUpdate {
  final List<ModelType> _currentFields;
  final List<ModelType> _nextFields;
  final dynamic _currentState;
  dynamic _nextState;

  ModelUpdate(ImmutableModel currentModel)
      : _currentFields = List<ModelType>.unmodifiable(currentModel.fields),
        _nextFields = List<ModelType>.of(currentModel.fields, growable: false),
        _currentState = currentModel.currentState,
        _nextState = currentModel.currentState;

  void _addToNext(ModelType currentFieldFor, ModelType nextField) {
    final fieldIdx = _currentFields.indexWhere(
      (_currentField) => identical(_currentField, currentFieldFor),
    );
    if (fieldIdx == -1)
      throw ModelFieldSelectError(currentFieldFor, _currentFields);
    // _currentFields and _nextFields have the same order
    _nextFields[fieldIdx] = nextField;
  }

  bool isStrict() {
    for (var i = 0; i < _currentFields.length; i++) {
      // if there was no update made to a field, return false
      if (identical(_currentFields[i], _nextFields[i])) return false;
    }
    return true;
  }

  void addUpdatedField(
    ModelType currentField,
    ModelType<dynamic, dynamic> updatedField,
  ) =>
      _addToNext(currentField, updatedField as ModelType);

  void addFieldUpdate(FieldUpdate fieldUpdate) {
    final updatedField = fieldUpdate.field(fieldUpdate.update);
    addUpdatedField(fieldUpdate.field, updatedField);
  }

  void setNextState(nextState) {
    if (nextState != _currentState) _nextState = nextState;
  }

  F getField<F extends ModelType<dynamic, dynamic>>(F currentField) {
    final fieldIdx = _currentFields.indexWhere(
      (_currentField) => identical(_currentField, currentField),
    );
    if (fieldIdx == -1) {
      throw ModelFieldSelectError(currentField as ModelType, _currentFields);
    }
    return _nextFields[fieldIdx] as F;
  }

  S nextState<S>() => _nextState;

  @override
  String toString() {
    var s = 'ModelUpdate:'
        '\n State: $_currentState -> $_nextState'
        '\n Fields:';
    for (var i = 0; i < _currentFields.length; i++) {
      s += '\n  ${_currentFields[i]} -> ${_nextFields[i]}';
    }
    return s;
  }
}
