import 'package:valid/valid.dart';

import '../model_types/primitives/model_value_type.dart';

/// A model of a valid password string.
class ModelPassword extends ModelValueType<ModelPassword, String>
    with ValueType {
  static bool validator(String pwStr) =>
      pwStr.isEmpty ||
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(pwStr);

  ModelPassword(
    String? passwordString, {
    String fieldLabel = 'password',
  }) : super.initial(
          passwordString,
          validator: validator,
          fieldLabel: fieldLabel,
        );

  ModelPassword._next(ModelPassword previous, String value)
      : super.constructNext(previous, value);

  @override
  ModelPassword buildNext(String nextValue) =>
      ModelPassword._next(this, nextValue);

  // shouldn't be deserializing passwords
  @override
  String? deserializer(dynamic serialized) => null;
}
