import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, ImmutableModel<UserState>> {
  UserBloc() : super(userStateModel);

  // derried values
  int listTotal() => UserState.listOfEvens(state).reduce((value, element) => value + element);

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
    } else if (event is UpdateChosenValues) {
      yield state.updateIfIn({"chosen_values": event.updates}, const UserAuthed());
    } else if (event is SortListAsc) {
      yield state.updateIfIn({
        "chosen_values": {"list_of_evens": (list) => list..sort((a, b) => a > b ? 1 : a == b ? 0 : -1)}
      }, const UserAuthed());
    } else if (event is SortListDec) {
      yield state.updateIfIn({
        "chosen_values": {"list_of_evens": (list) => list..sort((a, b) => a < b ? 1 : a == b ? 0 : -1)}
      }, const UserAuthed());
    }
  }
}
