import 'package:immutable_model/src/immutable_model/model_update.dart';

typedef IMLogger = void Function(ModelUpdate modelUpdate);

abstract class ImmutableModelLogger {
  static IMLogger get log => (m) => print(m);
}
