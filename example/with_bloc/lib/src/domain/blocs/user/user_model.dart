import 'package:immutable_model/immutable_model.dart';

enum Seasons { Spring, Summer, Winter, Autumn }

class UserModel extends ImmutableModel<UserModel, UserState> {
  final ModelEmail email;
  final ModelString enteredText;
  final ModelInt validatedNumber;
  final ModelDouble enteredDouble;
  final ModelBool chosenBool;
  final ModelEnum chosenEnum;
  final ModelDateTime dateBegin;
  final ModelDateTime dateEnd;
  final ModelList<int> listOfEvens;

  UserModel()
      : email = ModelEmail('email'),
        enteredText = ModelString('entered_text', ''),
        validatedNumber = ModelInt('validated_number', 0, (n) => n >= 0),
        enteredDouble = ModelDouble('entered_double', 13 / 7),
        chosenBool = ModelBool('chosen_bool', false),
        chosenEnum = ModelEnum('chosen_enum', Seasons.values, Seasons.Spring),
        dateBegin = ModelDateTime('date_begin', DateTime.utc(2020)),
        dateEnd = ModelDateTime('date_begin', DateTime.utc(2020, 1, 2)),
        listOfEvens = ModelList(
          'list_of_evens',
          [2, 4, 6, 8],
          (l) => l.every((e) => e.isEven),
        ),
        super.initial(initialState: const UserUnauthed());

  UserModel._next(
    this.email,
    this.enteredText,
    this.validatedNumber,
    this.enteredDouble,
    this.chosenBool,
    this.chosenEnum,
    this.dateBegin,
    this.dateEnd,
    this.listOfEvens,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  UserModel build(ModelUpdate modelUpdate) => UserModel._next(
        modelUpdate.getField(email),
        modelUpdate.getField(enteredText),
        modelUpdate.getField(validatedNumber),
        modelUpdate.getField(enteredDouble),
        modelUpdate.getField(chosenBool),
        modelUpdate.getField(chosenEnum),
        modelUpdate.getField(dateBegin),
        modelUpdate.getField(dateEnd),
        modelUpdate.getField(listOfEvens),
        modelUpdate,
      );

  @override
  List<SerializableValidType<SerializableValidType, dynamic>> get fields => [
        email,
        enteredText,
        validatedNumber,
        enteredDouble,
        chosenBool,
        chosenEnum,
        dateBegin,
        dateEnd,
        listOfEvens,
      ];

  @override
  ModelValidator get validator => () => dateBegin.value.isBefore(dateEnd.value);
}

abstract class UserState {
  const UserState();
}

class UserUnauthed extends UserState {
  const UserUnauthed();
}

class UserAuthed extends UserState {
  const UserAuthed();
}
