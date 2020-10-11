import 'package:immutable_model/immutable_model.dart';

enum Seasons { Spring, Summer, Winter, Autumn }

final userStateModel = ImmutableModel<UserState>(
  {
    "email": M.email(),
    "chosen_values": M.inner({
      "entered_text": M.str(initial: "Hello M!"),
      "validated_number": M.nt(initial: 0, validator: (n) => n >= 0),
      "entered_double": M.dbl(initial: 13 / 7),
      "chosen_bool": M.bl(initial: true),
      "chosen_enum": M.enm(Seasons.values, Seasons.Spring),
      "date_begin": M.dt(initial: DateTime.now()),
      "date_end": M.dt(initial: DateTime.now().add(Duration(days: 1))),
      'list_of_evens': M.ntList(
          initial: [2, 4, 6, 8], itemValidator: (n) => n.isEven, append: false),
    }),
  },
  modelValidator: (modelMap) => UserState.dateBeginSel
      .valueFromModelMap(modelMap)
      .isBefore(UserState.dateEndSel.valueFromModelMap(modelMap)),
  initialState: const UserUnauthed(),
);

abstract class UserState {
  static const _chosenValues = "chosen_values";
  static const enteredTextSel =
      ModelSelector<String>(_chosenValues + ".entered_text");
  static const validatedNumberSel =
      ModelSelector<int>(_chosenValues + ".validated_number");
  static const enteredDoubleSel =
      ModelSelector<double>(_chosenValues + ".entered_double");
  static const chosenBoolSel =
      ModelSelector<bool>(_chosenValues + ".chosen_bool");
  static const chosenEnumSel =
      ModelSelector<String>(_chosenValues + ".chosen_enum");
  static const dateBeginSel =
      ModelSelector<DateTime>(_chosenValues + ".date_begin");
  static const dateEndSel =
      ModelSelector<DateTime>(_chosenValues + ".date_end");
  static const listOfEvensSel =
      ModelSelector<List<int>>(_chosenValues + ".list_of_evens");

  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}
