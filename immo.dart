import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:vibefire/utils/model_state.dart';

typedef ModelValidator<D> = bool Function(D model);

@immutable
class IMMO<P, S extends ModelState<S>> {
  final P props;
  final S currentState;

  final P? _initialPropsModel;
  final IMMO<P, S>? _previous;

  final ModelValidator<P>? _validator;

  P get initialProps => _initialPropsModel ?? props;

  bool validate(P propsModel) => _validator == null || _validator!(propsModel);

  IMMO({
    required P propsModel,
    required S initialState,
    ModelValidator<P>? validator,
  })  : props = propsModel,
        currentState = initialState,
        _validator = validator,
        _initialPropsModel = null,
        _previous = null;

  IMMO._next(
    IMMO<P, S> previous,
    P nextPropsModel,
    S nextState,
  )   : props = nextPropsModel,
        currentState = nextState,
        _validator = previous._validator,
        _initialPropsModel = previous.initialProps,
        _previous = previous;

  IMMO<P, S> _buildNext({
    P? nextProps,
    S? nextState,
  }) {
    final ns = nextState ?? currentState;
    final nm = nextProps ?? props;

    if (!currentState.canTransitionTo(ns)) {
      log('invalid state transition: $ns');
      return this;
    }
    if (nextProps != null && !validate(nextProps)) {
      log('invalid update: $nextProps');
      return this;
    }

    return IMMO._next(
      this,
      nm,
      ns,
    );
  }

  bool didPropChange<T>(
    T Function(P propsModel) propSelector,
  ) =>
      _previous == null
          ? true
          : propSelector(_previous!.props) != propSelector(props);

  bool didStateChange() =>
      _previous == null ? true : _previous!.currentState != currentState;

  bool isIn<T extends ModelState<S>>() => currentState is T;

  void ifIn<T extends ModelState<S>>({
    required void Function(T inState) then,
    void Function()? otherwise,
  }) {
    if (isIn<T>()) {
      then(currentState as T);
    } else {
      if (otherwise != null) otherwise();
    }
  }

  IMMO<P, S> transitionTo(S nextState) => _buildNext(
        nextState: nextState,
      );

  IMMO<P, S> update(P updater(P props)) => _buildNext(
        nextProps: updater(props),
      );

  IMMO<P, S> updateAndTransitionTo(P updater(P props), S nextState) =>
      _buildNext(
        nextProps: updater(props),
        nextState: nextState,
      );

  IMMO<P, S> reset() => _buildNext(
        nextProps: initialProps,
      );

  IMMO<P, S> resetAndTransitionTo(S nextState) => _buildNext(
        nextProps: initialProps,
        nextState: nextState,
      );

  @override
  String toString() => 'IMMO<$S, $P>'
      '\n- State: $currentState'
      '\n- Props:\n$props';
}
