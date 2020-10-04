import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import 'user_state.dart';
import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, ImmutableModel<UserState>> {
  UserBloc() : super(userStateModel);

  // derived values
  int listTotal() => state
      .select(UserState.listOfEvensSel)
      .reduce((value, element) => value + element);

  @override
  Stream<ImmutableModel<UserState>> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is AuthUser) {
      yield state.transitionToAndUpdate(const UserAuthed(), {
        'email': event.email,
      });
    } else if (event is UnauthUser) {
      yield state.resetAndTransitionTo(const UserUnauthed());
    } else if (event is UpdateValues) {
      yield state.updateWithSelectorIfIn(
          event.selector, event.value, const UserAuthed());
    } else if (event is SortListAsc) {
      yield state.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          (list) => list
            ..sort((a, b) => a > b
                ? 1
                : a == b
                    ? 0
                    : -1),
          const UserAuthed());
    } else if (event is SortListDec) {
      yield state.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          (list) => list
            ..sort((a, b) => a < b
                ? 1
                : a == b
                    ? 0
                    : -1),
          const UserAuthed());
    }
  }
}
