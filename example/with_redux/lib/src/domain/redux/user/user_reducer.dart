import 'package:redux/redux.dart';
import 'package:immutable_model/immutable_model.dart';

import 'user_state.dart';
import 'user_action.dart';

int listTotal(List<int> l) => l.reduce((value, element) => value + element);

class UserReducer extends ReducerClass<ImmutableModel<UserState>> {
  ImmutableModel<UserState> call(model, action) {
    if (action is AuthUser) {
      return model.transitionToAndUpdate(const UserAuthed(), {
        'email': action.email,
      });
    } else if (action is UnauthUser) {
      return model.resetAndTransitionTo(const UserUnauthed());
    } else if (action is UpdateValues) {
      return model.updateWithSelectorIfIn(
          action.selector, action.value, const UserAuthed());
    } else if (action is SortListAsc) {
      return model.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          (list) => list
            ..sort((a, b) => a > b
                ? 1
                : a == b
                    ? 0
                    : -1),
          const UserAuthed());
    } else if (action is SortListDec) {
      return model.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          (list) => list
            ..sort((a, b) => a < b
                ? 1
                : a == b
                    ? 0
                    : -1),
          const UserAuthed());
    }

    return model;
  }
}
