/// The main library, exposing the [ImmutableModel] class, [ModelSelector] and the static [M] class containing model shorthands.
///
/// Using the shorthands defined in [M] is the recommended way of defining [ModelType]'s used in an [ImmutableModel].
library immutable_model;

// todo: add logging

export 'src/errors.dart';
export 'src/exceptions.dart';
export 'src/typedefs.dart';
export 'src/model_type.dart';
// model types
// - inner
export 'src/model_types/model_inner.dart';
// - enum
export 'src/model_types/model_enum.dart';
// - values
export 'src/model_types/primitives/model_bool.dart';
export 'src/model_types/primitives/model_datetime.dart';
export 'src/model_types/primitives/model_double.dart';
export 'src/model_types/primitives/model_int.dart';
export 'src/model_types/primitives/model_string.dart';
export 'src/model_types/primitives/model_value_type.dart';
// - lists
export 'src/model_types/lists/model_list.dart';
export 'src/model_types/lists/model_value_list.dart';
// value types
export 'src/value_types/model_email.dart';
export 'src/value_types/model_password.dart';
// immutable model
export 'src/immutable_model/immutable_model.dart';
export 'src/immutable_model/field_update.dart';
export 'src/immutable_model/model_update.dart';
export 'src/immutable_model/model_state.dart';

// rexport valid
export 'package:valid/valid.dart';
