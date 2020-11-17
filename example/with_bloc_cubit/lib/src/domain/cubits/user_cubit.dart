import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../models/user_model.dart';

class UserCubit extends Cubit<ImmutableModel<UserState>> {
  UserCubit() : super(userModel);

  // derived values
  int listTotal() => state
      .selectValue(UserState.listOfEvensSel)
      .reduce((value, element) => value + element);

  void authUser(ModelEmail email) =>
      emit(state.transitionToAndUpdate(const UserAuthed(), {
        'email': email,
      }));

  void unauthUser() => emit(state.resetAndTransitionTo(const UserUnauthed()));

  void updateValues(ModelSelector selector, dynamic update) =>
      emit(state.updateWithSelectorIfIn(selector, update, const UserAuthed()));

  void sortListAsc() {
    ModelIntList lm = state.selectModel(UserState.listOfEvensSel);
    updateValues(
        UserState.listOfEvensSel,
        lm.sort((a, b) => a > b
            ? 1
            : a == b
                ? 0
                : -1));
  }

  void sortListDec() {
    ModelIntList lm = state.selectModel(UserState.listOfEvensSel);
    updateValues(
        UserState.listOfEvensSel,
        lm.sort((a, b) => a < b
            ? 1
            : a == b
                ? 0
                : -1));
  }
}
