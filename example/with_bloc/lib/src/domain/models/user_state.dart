import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

enum _Seasons { Summer, Winter, Autum, Spring }

final userStateModel = ImmutableModel<UserState>(
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
      'list_of_evens': M.ntList(initialValue: [2, 4, 6, 8], validator: (n) => n.isEven, append: false),
    }),
  },
  modelValidator: (modelMap) =>
      (modelMap['chosen_values']['date_begin'] as DateTime).isBefore(modelMap['chosen_values']['date_end'] as DateTime),
  initalState: const UserUnauthed(),
  cacheBufferSize: 10,
);

abstract class UserState {
  static final chosenValues = (ImmutableModel<UserState> model) => model['chosen_values'] as ModelInner;
  static final enteredText = (ImmutableModel<UserState> model) => chosenValues(model)['entered_text'] as String;
  static final validatedNumber = (ImmutableModel<UserState> model) => chosenValues(model)['validated_number'] as int;
  static final enteredDouble = (ImmutableModel<UserState> model) => chosenValues(model)['entered_double'] as double;
  static final chosenBool = (ImmutableModel<UserState> model) => chosenValues(model)['chosen_bool'] as bool;
  static final chosenEnum = (ImmutableModel<UserState> model) => chosenValues(model)['chosen_enum'] as String;
  static final dateBegin = (ImmutableModel<UserState> model) => chosenValues(model)['date_begin'] as DateTime;
  static final dateEnd = (ImmutableModel<UserState> model) => chosenValues(model)['date_end'] as DateTime;
  static final listOfEvens = (ImmutableModel<UserState> model) => chosenValues(model)['list_of_evens'] as List<int>;

  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}
