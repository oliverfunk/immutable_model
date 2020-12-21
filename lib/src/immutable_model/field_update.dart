import 'package:meta/meta.dart';

import '../serializable_valid_type.dart';

@immutable
class FieldUpdate {
  final SerializableValidType field;
  final dynamic update;

  const FieldUpdate(this.field, this.update);
}
