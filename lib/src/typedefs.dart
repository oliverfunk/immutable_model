import 'model_type.dart';

/// A function that updates the value of a model based on its [currentValue].
typedef ValueUpdater = dynamic Function(dynamic currentValue);

/// A function that validates an item from a list
typedef ListItemValidator<V> = bool Function(V listItem);

/// A function that validates [modelMap].
///
/// Note [modelMap] is read-only.
typedef ModelMapValidator = bool Function(Map<String, ModelType> modelMap);

/// A function that validates the [value] passed to it.
typedef ValueValidator<V> = bool Function(V value);
