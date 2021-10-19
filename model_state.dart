import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ModelState<S extends ModelState<S>> extends Equatable {
  const ModelState();

  @nonVirtual
  ModelState<S> transitionTo(ModelState<S> nextState) =>
      canTransitionTo(nextState) ? nextState : this;

  @nonVirtual
  bool canTransitionTo(ModelState<S> nextState) {
    if (this == nextState && canSelfTransition) {
      return true;
    } else if (transitionableStates.contains(S) ||
        transitionableStates.contains(nextState.runtimeType)) {
      return true;
    }
    return false;
  }

  @nonVirtual
  @override
  Type get runtimeType => super.runtimeType;

  bool get canSelfTransition => true;

  List<Type> get transitionableStates => [S];

  @override
  List<Type> get props => [runtimeType];

  @override
  String toString() => '$runtimeType';
}
