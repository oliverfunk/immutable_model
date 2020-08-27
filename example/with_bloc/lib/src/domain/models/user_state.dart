import 'package:immutable_model/immutable_model.dart';

enum _Seasons { Summer, Winter, Autum, Spring }

abstract class UserState {
  static final model = ImmutableModel<UserState>(
    {
      "email": M.email(defaultEmail: "oli.funk@gmail.com"),
      "password": M.password(),
      "some_values": M.inner({
        "a_str": M.str(initialValue: "Hello M!"),
        "validated_number": M.nt(initialValue: 0, validator: (n) => n >= 0),
        "a_double": M.dbl(initialValue: 13 / 7),
        "this_is_great": M.bl(initialValue: true),
        "favourite_season": M.enm(_Seasons.values, _Seasons.Summer),
        "date_begin": M.dt(initialValue: DateTime.now()),
        "date_end": M.dt(initialValue: DateTime.now().add(Duration(seconds: 100))),
        'list_of_evens': M.ntList(initialValue: [2, 4, 6, 8], validator: (n) => n.isEven),
      }),
    },
    modelValidator: (modelMap) =>
        (modelMap['some_values']['date_begin'] as DateTime).isBefore(modelMap['some_values']['date_end'] as DateTime),
    initalState: UserUnauthed(),
  );

  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}
