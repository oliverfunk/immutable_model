import 'package:immutable_model/model_types.dart';
import 'package:redux/redux.dart';
import 'package:immutable_model/immutable_model.dart';

import 'user_model.dart';
import 'user_action.dart';

int listTotal(List<int> l) => l.reduce((value, element) => value + element);

class UserReducer extends ReducerClass<ImmutableModel<UserState>> {
  ImmutableModel<UserState> call(model, action) {
    if (action is AuthUser) {
      return model.transitionToAndUpdate(
        const UserAuthed(),
        {
          'email': action.email,
        },
      );
    } else if (action is UnauthUser) {
      return model.resetAndTransitionTo(const UserUnauthed());
    } else if (action is UpdateValues) {
      return model.updateWithSelectorIfIn(
        action.selector,
        action.value,
        const UserAuthed(),
      );
    } else if (action is SortListAsc) {
      final ModelIntList lm = model.selectModel(UserState.listOfEvensSel);
      return model.updateWithSelectorIfIn(
        UserState.listOfEvensSel,
        lm.sort((a, b) => a > b
            ? 1
            : a == b
                ? 0
                : -1),
        const UserAuthed(),
      );
    } else if (action is SortListDec) {
      final ModelIntList lm = model.selectModel(UserState.listOfEvensSel);
      return model.updateWithSelectorIfIn(
          UserState.listOfEvensSel,
          lm.sort((a, b) => a < b
              ? 1
              : a == b
                  ? 0
                  : -1),
          const UserAuthed());
    }

    return model;
  }
}
