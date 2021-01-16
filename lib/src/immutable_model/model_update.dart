import 'package:meta/meta.dart';

import 'model_state.dart';
import '../errors.dart';
import '../model_type.dart';

@immutable
class ModelUpdate<S> {
  final ModelState _currentState;
  final ModelState _nextState;
  final List<ModelType> _currentFields;
  final List<ModelType> _nextFields;

  ModelUpdate(
    ModelState currentState,
    List<ModelType> currentFields,
    ModelState<S> nextState,
    List<ModelType> nextFields,
  )   : _currentFields = currentFields,
        _currentState = currentState,
        _nextFields = _setNextFields(
          currentFields,
          nextFields,
        ),
        _nextState = _setNextState<S>(
          currentState as ModelState<S>,
          nextState,
        );

  static List<ModelType> _setNextFields(
    List<ModelType> currentFields,
    List<ModelType> nextFields,
  ) {
    final merger = List<ModelType>.of(currentFields, growable: false);

    // replace each "current" field in merger with the matching one from next
    for (var nextField in nextFields) {
      final fieldIdx = currentFields.indexWhere(
        (_currentField) => _currentField.label == nextField.label,
      );
      if (fieldIdx == -1) {
        throw ModelFieldSelectError(nextField, currentFields);
      }

      // currentFields and merger have the same order
      merger[fieldIdx] = nextField;
    }

    return merger;
  }

  static ModelState<S> _setNextState<S>(
    ModelState<S> currentState,
    ModelState<S> nextState,
  ) {
    if (currentState == nextState && currentState.canSelfTransition) {
      return currentState;
    } else if (currentState.transitionableStates.contains(S) ||
        currentState.transitionableStates.contains(nextState.runtimeType)) {
      return nextState;
    } else {
      throw ModelStateTransitionError(currentState, nextState);
    }
  }

  bool isStrict() {
    for (var i = 0; i < _currentFields.length; i++) {
      // if there was no update made to a field, or it was reset, return false
      if (identical(_currentFields[i], _nextFields[i]) ||
          identical(_currentFields[i].initial, _nextFields[i])) {
        return false;
      }
    }
    return true;
  }

  F forField<F extends ModelType<dynamic, dynamic>>(F currentField) {
    final fieldIdx = _currentFields.indexWhere(
      (_currentField) => _currentField.label == currentField.label,
    );
    if (fieldIdx == -1) {
      throw ModelFieldSelectError(currentField as ModelType, _currentFields);
    }
    return _nextFields[fieldIdx] as F;
  }

  ModelState forState() => _nextState;

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
