import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:immutable_model/value_types.dart';

import '../models/user_state.dart';

class UserCubit extends Cubit<ImmutableModel<UserState>> {
  UserCubit() : super(UserState.model);

  ModelInner get someValues => state['chosen_values'] as ModelInner;

  void userAuthed(ModelEmail email, ModelPassword password) => emit(state.transitionToAndUpdate(UserAuthed(), {
        'email': email,
        'password': password,
      }));

  void updateSomeValues(Map<String, dynamic> updates) =>
      emit(state.updateIfIn({"chosen_values": updates}, const UserAuthed()));
}
