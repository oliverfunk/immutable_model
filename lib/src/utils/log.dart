import 'package:logging/logging.dart';

import '../exceptions.dart';

void logException(ImmutableModelException exc) {
  Logger('ImmutableModel').warning(exc.toString());
}

R logExceptionAndReturn<R>(R toReturn, ImmutableModelException exc) {
  logException(exc);
  return toReturn;
}
