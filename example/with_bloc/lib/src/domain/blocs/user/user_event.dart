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

class UpdateChosenValues extends UserEvent {
  final Map<String, dynamic> updates;

  const UpdateChosenValues(this.updates);
}

class SortListAsc extends UserEvent {
  const SortListAsc();
}

class SortListDec extends UserEvent {
  const SortListDec();
}
