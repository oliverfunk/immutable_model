import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import 'user_model.dart';
import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, ImmutableModel<UserState>> {
  UserBloc() : super(userModel);

  // derived values
  int listTotal() => state
      .selectValue(UserState.listOfEvensSel)
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
      final ModelIntList lm = state.selectModel(UserState.listOfEvensSel);
      yield state.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          lm.sort((a, b) => a > b
              ? 1
              : a == b
                  ? 0
                  : -1),
          const UserAuthed());
    } else if (event is SortListDec) {
      final ModelIntList lm = state.selectModel(UserState.listOfEvensSel);
      yield state.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          lm.sort((a, b) => a < b
              ? 1
              : a == b
                  ? 0
                  : -1),
          const UserAuthed());
    }
  }
}
