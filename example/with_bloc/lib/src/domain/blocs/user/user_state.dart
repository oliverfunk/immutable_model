import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

enum Seasons { Spring, Summer, Winter, Autumn }

final userStateModel = ImmutableModel<UserState>(
  {
    "email": M.email(),
    "chosen_values": M.inner({
      "entered_text": M.str(initialValue: "Hello M!"),
      "validated_number": M.nt(initialValue: 0, validator: (n) => n >= 0),
      "entered_double": M.dbl(initialValue: 13 / 7),
      "chosen_bool": M.bl(initialValue: true),
      "chosen_enum": M.enm(Seasons.values, Seasons.Spring),
      "date_begin": M.dt(initialValue: DateTime.now()),
      "date_end": M.dt(initialValue: DateTime.now().add(Duration(days: 1))),
      'list_of_evens': M.ntList(initialList: [2, 4, 6, 8], itemValidator: (n) => n.isEven, append: false),
    }),
  },
  modelValidator: (modelMap) {
    final chosenValuesInner = modelMap['chosen_values'] as ModelInner;
    return (chosenValuesInner['date_begin'] as DateTime).isBefore(chosenValuesInner['date_end'] as DateTime);
  },
  initialState: const UserUnauthed(),
);

abstract class UserState {
  static const _chosenValues = "chosen_values";
  static const enteredTextSel = ModelSelector<String>(_chosenValues + ".entered_text");
  static const validatedNumberSel = ModelSelector<int>(_chosenValues + ".validated_number");
  static const enteredDoubleSel = ModelSelector<double>(_chosenValues + ".entered_double");
  static const chosenBoolSel = ModelSelector<bool>(_chosenValues + ".chosen_bool");
  static const chosenEnumSel = ModelSelector<String>(_chosenValues + ".chosen_enum");
  static const dateBeginSel = ModelSelector<DateTime>(_chosenValues + ".date_begin");
  static const dateEndSel = ModelSelector<DateTime>(_chosenValues + ".date_end");
  static const listOfEvensSel = ModelSelector<List<int>>(_chosenValues + ".list_of_evens");

  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}