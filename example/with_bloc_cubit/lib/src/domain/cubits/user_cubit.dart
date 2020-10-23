import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import '../models/user_state.dart';

class UserCubit extends Cubit<ImmutableModel<UserState>> {
  UserCubit() : super(userStateModel);

  // derived values
  int listTotal() => state
      .selectValue(UserState.listOfEvensSel)
      .reduce((value, element) => value + element);

  void authUser(ModelEmail email) =>
      emit(state.transitionToAndUpdate(const UserAuthed(), {
        'email': email,
      }));

  void unauthUser() => emit(state.resetAndTransitionTo(const UserUnauthed()));

  void updateValues<V>(ModelSelector<V> selector, V value) =>
      emit(state.updateWithSelectorIfIn(selector, value, const UserAuthed()));

  void sortListAsc() => updateValues(
      UserState.listOfEvensSel,
      (list) => list
        ..sort((a, b) => a > b
            ? 1
            : a == b
                ? 0
                : -1));

  void sortListDec() => updateValues(
      UserState.listOfEvensSel,
      (list) => list
        ..sort((a, b) => a < b
            ? 1
            : a == b
                ? 0
                : -1));
}
