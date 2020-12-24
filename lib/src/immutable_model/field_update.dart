import 'package:meta/meta.dart';

import '../model_type.dart';

@immutable
class FieldUpdate {
  final ModelType field;
  final dynamic update;

  const FieldUpdate({
    required this.field,
    required this.update,
  });
}
