import 'package:immutable_model/src/immutable_model/model_update.dart';

/// A function that validates an immutable model
typedef ModelValidator = bool Function(ModelUpdate modelUpdate);
