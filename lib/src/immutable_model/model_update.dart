import 'package:immutable_model/src/immutable_model/field_update.dart';
import 'package:meta/meta.dart';
import 'package:valid/valid.dart';

import '../serializable_valid_type.dart';

@immutable
class ModelUpdate<S> {
  final List<SerializableValidType> _fields;
  final List<SerializableValidType> _updatedFields = List.empty(growable: true);
  final S _stateUpdate;

  ModelUpdate(this._fields, this._stateUpdate);

  SerializableValidType _applyFieldUpdate(
    FieldUpdate fieldUpdate,
  ) {
    final field = fieldUpdate.field;
    final update = fieldUpdate.update;

    if (update is SerializableValidType) {
      return field.nextFromOther(update) as SerializableValidType;
    } else if (update is ValueUpdater) {
      return field.nextWithFunc(update) as SerializableValidType;
    } else {
      return field.next(update) as SerializableValidType;
    }
  }

  void _addToUpdated(SerializableValidType field) {
    final fieldIdx = _updatedFields.indexWhere(
      (f) => f.fieldLabel == field.fieldLabel,
    );
    if (fieldIdx == -1) {
      _updatedFields.add(field);
    } else {
      // replace
      _updatedFields[fieldIdx] = field;
    }
  }

  bool isStrict() =>
      _updatedFields.isEmpty || _updatedFields.length == _fields.length;

  void addFieldUpdate(FieldUpdate fieldUpdate) =>
      _addToUpdated(_applyFieldUpdate(fieldUpdate));

  void addUpdatedField(SerializableValidType<dynamic, dynamic> updatedField) =>
      _addToUpdated(updatedField as SerializableValidType);

  F getField<F extends SerializableValidType<dynamic, dynamic>>(F field) =>
      _updatedFields.firstWhere(
        (_updatedField) => field.fieldLabel == _updatedField.fieldLabel,
        orElse: () => _fields.firstWhere(
          (_field) => field.fieldLabel == _field.fieldLabel,
        ),
      ) as F;

  S get stateUpdate => _stateUpdate;

  @override
  String toString() => '**ModelUpdate:'
      '\n Next state: ${_stateUpdate.runtimeType}'
      '\n Field Updates: ${_fields}';
}
