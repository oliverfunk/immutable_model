import 'package:logging/logging.dart';

import '../exceptions.dart';

void logException(ModelException exc) {
  Logger('ImmutableModel').warning(exc.toString());
}

R logExceptionAndReturn<R>(R toReturn, ModelException exc) {
  logException(exc);
  return toReturn;
}
