import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/value_types.dart';

import '../models/user_state.dart';

class UserCubit extends Cubit<ImmutableModel<UserState>> {
  UserCubit() : super(UserState.model);

  void userAuthed(ModelEmail email, ModelPassword password) => emit(state.transitionToWithUpdate(UserAuthed(), {
        'email': email,
        'password': password,
      }));

  void updateSomeValues(Map<String, dynamic> updates) => emit(state.update({"some_values": updates}));
}
