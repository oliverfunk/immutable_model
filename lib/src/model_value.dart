import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'exceptions.dart';

typedef V Updater<V>(V currentValue);
typedef bool Validator<V>(V value);

@immutable
abstract class ModelValue<M extends ModelValue<M, V>, V> extends Equatable {
  V get value;

  M get initialModel;

  /// Validates [toValidate] using the defined [validator] for this [ModelValue].
  V validate(V toValidate) => toValidate;

  @protected
  M build(V next);

  /// Validate [value] and return a new instance of this [ModelValue].
  /// If [value] is null, return the initial model
  @nonVirtual
  M next(V value) => value == null ? initialModel : build(validate(value));

  @nonVirtual
  M nextFromDynamic(dynamic value) =>
      value == null ? next(null) : value is V ? next(value) : throw ModelTypeException<V>(value, modelFieldName);

  @nonVirtual
  M nextFromModel(M model) => initialModel == model.initialModel ? model : throw Exception('model badness');

  /// Return this [ModelValue] as a serializable object for the JSON.encode() method.
  dynamic asSerializable() => value;

  V deserializer(dynamic jsonValue) =>
      jsonValue == null ? throw Error() : jsonValue is V ? jsonValue : throw ModelDeserializeException(jsonValue, modelFieldName);

  /// Returns the model field name string for this [ModelValue] in some.
  /// Useful for reflection and exceptions.
  String get modelFieldName => null;

  @nonVirtual
  Type get type => V;

  @override
  List<Object> get props => [value];

  @override
  String toString() => "${modelFieldName == null ? "" : modelFieldName + ": "}$value ($V)";
}
