part of 'user_bloc.dart';

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
