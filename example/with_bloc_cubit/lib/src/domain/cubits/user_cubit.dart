import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../models/user_model.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel());

  // derived values
  static int listTotal(List<int> list) =>
      list.reduce((value, element) => value + element);

  void authUser(ModelEmail email) => emit(state.updateFieldAndTransitionTo(
        const UserAuthed(),
        field: state.email,
        update: email,
      ));

  void unauthUser() =>
      emit(state.resetAllAndTransitionTo(const UserUnauthed()));

  void updateValue(ModelType field, dynamic update) =>
      emit(state.updateFieldIfIn(
        const UserAuthed(),
        field: field,
        update: update,
      ));

  void sortListAsc() {
    updateValue(
      state.listOfEvens,
      (List l) => (l)
        ..sort((a, b) => a > b
            ? 1
            : a == b
                ? 0
                : -1),
    );
  }

  void sortListDec() {
    updateValue(
      state.listOfEvens,
      (List l) => (l)
        ..sort((a, b) => a < b
            ? 1
            : a == b
                ? 0
                : -1),
    );
  }
}
