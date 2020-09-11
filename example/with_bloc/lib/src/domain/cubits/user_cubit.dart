import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import '../models/user_state.dart';

class UserCubit extends Cubit<ImmutableModel<UserState>> {
  UserCubit() : super(userStateModel);

  void userAuthed(ModelEmail email) => emit(state.transitionToAndUpdate(const UserAuthed(), {
        'email': email,
      }));

  void userUnauthed() => emit(state.resetAndTransitionTo(const UserUnauthed()));

  void updateSomeValues(Map<String, dynamic> updates) =>
      emit(state.updateIfIn({"chosen_values": updates}, const UserAuthed()));

  void sortListAsc() => updateSomeValues({"list_of_evens": (list) => list.sort((a, b) => a > b ? 1 : a == b ? 0 : -1)});

  void sortListDec() => updateSomeValues({"list_of_evens": (list) => list.sort((a, b) => a < b ? 1 : a == b ? 0 : -1)});
}
