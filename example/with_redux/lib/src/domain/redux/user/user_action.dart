import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

@immutable
abstract class UserAction {
  const UserAction();
}

class AuthUser extends UserAction {
  final ModelEmail email;

  const AuthUser(this.email);
}

class UnauthUser extends UserAction {
  const UnauthUser();
}

class UpdateValues<V> extends UserAction {
  final ModelSelector<V> selector;
  final V value;

  const UpdateValues(this.selector, this.value);
}

class SortListAsc extends UserAction {
  const SortListAsc();
}

class SortListDec extends UserAction {
  const SortListDec();
}
