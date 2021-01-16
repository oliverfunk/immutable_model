import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ModelState<S> extends Equatable {
  const ModelState();

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
