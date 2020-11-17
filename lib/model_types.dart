/// The library exposing all base [ModelType] classes defined in this package.
///
/// Import this library if you need to access their type definitions,
/// otherwise use the shorthands defined in [M] when using them in an [ImmutableModel].
library model_types;

export 'src/model_type.dart';
// model lists
export 'src/model_types/lists/model_bool_list.dart';
export 'src/model_types/lists/model_datetime_list.dart';
export 'src/model_types/lists/model_double_list.dart';
export 'src/model_types/lists/model_enum_list.dart';
export 'src/model_types/lists/model_inner_list.dart';
export 'src/model_types/lists/model_int_list.dart';
export 'src/model_types/lists/model_string_list.dart';
export 'src/model_types/lists/model_value_list.dart';
// model enum
export 'src/model_types/model_enum.dart';
// model inner
export 'src/model_types/model_inner.dart';
// model values
export 'src/model_types/model_value.dart';
export 'src/model_types/primitives/model_bool.dart';
export 'src/model_types/primitives/model_datetime.dart';
export 'src/model_types/primitives/model_double.dart';
export 'src/model_types/primitives/model_int.dart';
export 'src/model_types/primitives/model_string.dart';
// value types
export 'src/value_types/model_email.dart';
export 'src/value_types/model_password.dart';
