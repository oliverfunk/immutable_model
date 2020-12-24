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
          fieldLabel: 'entered_text',
        ),
        validatedNumber = ModelInt(
          0,
          validator: (n) => n >= 0,
          fieldLabel: 'validated_number',
        ),
        enteredDouble = ModelDouble(
          13 / 7,
          fieldLabel: 'entered_double',
        ),
        chosenBool = ModelBool(
          false,
          fieldLabel: 'chosen_bool',
        ),
        chosenEnum = ModelEnum(
          Seasons.Spring,
          enumValues: Seasons.values,
          fieldLabel: 'chosen_enum',
        ),
        dateBegin = ModelDateTime(
          DateTime.utc(2020),
          fieldLabel: 'date_begin',
        ),
        dateEnd = ModelDateTime(
          DateTime.utc(2020, 1, 2),
          fieldLabel: 'date_end',
        ),
        listOfEvens = ModelList(
          [2, 4, 6, 8],
          validator: (l) => l.every((e) => e.isEven),
          fieldLabel: 'list_of_evens',
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
        modelUpdate.nextField(email),
        modelUpdate.nextField(enteredText),
        modelUpdate.nextField(validatedNumber),
        modelUpdate.nextField(enteredDouble),
        modelUpdate.nextField(chosenBool),
        modelUpdate.nextField(chosenEnum),
        modelUpdate.nextField(dateBegin),
        modelUpdate.nextField(dateEnd),
        modelUpdate.nextField(listOfEvens),
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
      mu.nextField(dateBegin).value!.isBefore(mu.nextField(dateEnd).value!);
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
