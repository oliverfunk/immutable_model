import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

@immutable
abstract class UserEvent {
  const UserEvent();
}

class AuthUser extends UserEvent {
  final ModelEmail email;

  const AuthUser(this.email);
}

class UnauthUser extends UserEvent {
  const UnauthUser();
}

class UpdateValues<V> extends UserEvent {
  final ModelSelector<V> selector;
  final V value;

  const UpdateValues(this.selector, this.value);
}

class SortListAsc extends UserEvent {
  const SortListAsc();
}

class SortListDec extends UserEvent {
  const SortListDec();
}
