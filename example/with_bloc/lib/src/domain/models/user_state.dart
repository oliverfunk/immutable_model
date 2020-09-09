import 'package:immutable_model/immutable_model.dart';

enum _Seasons { Summer, Winter, Autum, Spring }

abstract class UserState {
  static final model = ImmutableModel<UserState>(
    {
      "email": M.email(),
      "chosen_values": M.inner({
        "entered_text": M.str(initialValue: "Hello M!"),
        "validated_number": M.nt(initialValue: 0, validator: (n) => n >= 0),
        "entered_double": M.dbl(initialValue: 13 / 7),
        "chosen_bool": M.bl(initialValue: true),
        "chosen_enum": M.enm(_Seasons.values, _Seasons.Summer),
        "date_begin": M.dt(initialValue: DateTime.now()),
        "date_end": M.dt(initialValue: DateTime.now().add(Duration(days: 1))),
        'list_of_evens': M.ntList(initialValue: [2, 4, 6, 8], validator: (n) => n.isEven),
      }),
    },
    modelValidator: (modelMap) => (modelMap['chosen_values']['date_begin'] as DateTime)
        .isBefore(modelMap['chosen_values']['date_end'] as DateTime),
    initalState: const UserUnauthed(),
    cacheBufferSize: 10,
  );

  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}
