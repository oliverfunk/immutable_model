import 'package:immutable_model/immutable_model.dart';

enum Seasons { Spring, Summer, Winter, Autumn }

class UserModel extends ImmutableModel<UserModel, UserState> {
  final ModelEmail email;
  final ModelString enteredText;
  final ModelInt validatedNumber;
  final ModelDouble enteredDouble;
  final ModelBool chosenBool;
  final ModelEnum<Seasons> chosenEnum;
  final ModelDateTime dateBegin;
  final ModelDateTime dateEnd;
  final ModelList<int> listOfEvens;

  UserModel()
      : email = ModelEmail(null),
        enteredText = ModelString(
          '',
          label: 'entered_text',
        ),
        validatedNumber = ModelInt(
          0,
          validator: (n) => n >= 0,
          label: 'validated_number',
        ),
        enteredDouble = ModelDouble(
          13 / 7,
          label: 'entered_double',
        ),
        chosenBool = ModelBool(
          false,
          label: 'chosen_bool',
        ),
        chosenEnum = ModelEnum(
          Seasons.Spring,
          enumValues: Seasons.values,
          label: 'chosen_enum',
        ),
        dateBegin = ModelDateTime(
          DateTime.utc(2020),
          label: 'date_begin',
        ),
        dateEnd = ModelDateTime(
          DateTime.utc(2020, 1, 2),
          label: 'date_end',
        ),
        listOfEvens = ModelList(
          [2, 4, 6, 8],
          validator: (l) => l.every((e) => e.isEven),
          label: 'list_of_evens',
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
  List<ModelType<ModelType, dynamic>> get fields => [
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
  ModelValidator get validator => (mu) =>
      mu.getField(dateBegin).value!.isBefore(mu.getField(dateEnd).value!);
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
