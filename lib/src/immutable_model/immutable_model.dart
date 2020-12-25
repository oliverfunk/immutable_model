import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'field_update.dart';
import 'model_update.dart';
import '../immutable_model_logger.dart';
import '../typedefs.dart';
import '../errors.dart';
import '../model_type.dart';

/// Default placeholder state for [ImmutableModel]'s
class DefaultModelState {
  const DefaultModelState();
}

@immutable
abstract class ImmutableModel<M extends ImmutableModel<M, S>, S>
    extends Equatable {
  final S currentState;

  ImmutableModel.initial({
    S? initialState,
  }) : currentState = initialState ?? const DefaultModelState() as S {
    // check if the fields has been set and all have unique labels
    assert(
      fields.isNotEmpty,
      'Fields must be provided',
    );
    assert(
      fields.map((f) => f.label).toSet().length ==
          fields.map((f) => f.label).length,
      'Every field must have a unique label',
    );
    if (!validate(ModelUpdate(this))) {
      throw ModelInitializationError(M);
    }
  }

  ImmutableModel.constructNext(
    ModelUpdate modelUpdate,
  ) : currentState = modelUpdate.nextState();

  List<ModelType> get fields;

  bool get strictUpdates => false;

  @protected
  ModelValidator? get validator => null;

  @protected
  M build(ModelUpdate modelUpdate);

  M _next(ModelUpdate modelUpdate) {
    // todo: logging
    // ImmutableModelLogger.log(modelUpdate);
    if (strictUpdates && !modelUpdate.isStrict()) {
      print('update not strict');
      return this as M;
    }
    if (!validate(modelUpdate)) {
      print('update invalid');
      return this as M;
    }
    return build(modelUpdate);
  }

  @nonVirtual
  bool validate(ModelUpdate modelUpdate) =>
      validator == null || validator!(modelUpdate);

  /// Sets the [currentState] to [nextState].
  ///
  /// If [strictUpdates] is `true`, this will not work.
  @nonVirtual
  M transitionTo(S nextState) =>
      _next(ModelUpdate(this)..setNextState(nextState));

  @nonVirtual
  M updateFieldAndTransitionTo(
    S nextState, {
    required ModelType field,
    required dynamic update,
  }) {
    final _update = ModelUpdate(this);
    _update.addFieldUpdate(
      FieldUpdate(field: field, update: update),
    );
    _update.setNextState(nextState);
    return _next(_update);
  }

  @nonVirtual
  M updateField({
    required ModelType field,
    required dynamic update,
  }) =>
      updateFieldAndTransitionTo(currentState, field: field, update: update);

  @nonVirtual
  M updateFieldIfIn(
    S inState, {
    required ModelType field,
    required dynamic update,
  }) =>
      currentState.runtimeType == inState.runtimeType
          ? updateField(field: field, update: update)
          : throw ModelStateError(currentState, inState);

  /// Sets the [currentState] to [nextState] and updates the models values specified by [updates].
  @nonVirtual
  M updateFieldsAndTransitionTo(
    S nextState, {
    required List<FieldUpdate> fieldUpdates,
  }) {
    final _update = ModelUpdate(this);
    for (var fieldUpdate in fieldUpdates) {
      _update.addFieldUpdate(fieldUpdate);
    }
    _update.setNextState(nextState);
    return _next(_update);
  }

  @nonVirtual
  M updateFields({
    required List<FieldUpdate> fieldUpdates,
  }) =>
      updateFieldsAndTransitionTo(currentState, fieldUpdates: fieldUpdates);

  @nonVirtual
  M updateFieldsIfIn(
    S inState, {
    required List<FieldUpdate> fieldUpdates,
  }) =>
      currentState.runtimeType == inState.runtimeType
          ? updateFields(fieldUpdates: fieldUpdates)
          : throw ModelStateError(currentState, inState);

  @nonVirtual
  M resetFieldsAndTransitionTo(
    S nextState, {
    required List<ModelType> fieldsToReset,
  }) {
    final _update = ModelUpdate(this);
    for (var fieldToReset in fieldsToReset) {
      _update.addUpdatedField(fieldToReset, fieldToReset.reset());
    }
    _update.setNextState(nextState);
    return _next(_update);
  }

  @nonVirtual
  M resetFields({
    required List<ModelType> fieldsToReset,
  }) =>
      resetFieldsAndTransitionTo(currentState, fieldsToReset: fieldsToReset);

  /// Resets all field models to their initial instance.
  @nonVirtual
  M resetAll() => resetFieldsAndTransitionTo(
        currentState,
        fieldsToReset: fields,
      );

  /// Resets all the models in this to their [ModelType.initial] instance and sets the [currentState] to [nextState].
  @nonVirtual
  M resetAllAndTransitionTo(
    S nextState,
  ) =>
      resetFieldsAndTransitionTo(nextState, fieldsToReset: fields);

  // JSON

  Map<String, dynamic> toJson([bool includeNullValues = true]) {
    final jsonMap = <String, dynamic>{};
    for (var field in fields) {
      jsonMap[field.label] = field.asSerializable();
    }
    if (!includeNullValues) {
      jsonMap.removeWhere((k, v) => v == null);
    }
    return jsonMap;
  }

  M fromJson(Map<String, dynamic> jsonMap) {
    final _update = ModelUpdate(this);

    for (var field in fields) {
      if (jsonMap.containsKey(field.label)) {
        _update.addUpdatedField(
          field,
          field.nextWithSerialized(jsonMap[field.label]),
        );
      } else {
        // todo: log it
      }
    }
    return _next(_update);
  }

  @override
  @nonVirtual
  List<dynamic> get props => [currentState, fields];

  @override
  String toString() => toIndentableString(0);

  @nonVirtual
  String toIndentableString(int indentLevel) {
    final indent = ' ' * indentLevel;
    var s = '$indent$M<${currentState.runtimeType}>(';
    for (var field in fields) {
      s += '\n $indent${field.label}: $field';
    }
    s += '\n$indent)';
    return s;
  }
}
