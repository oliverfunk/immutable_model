import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../domain/blocs/user/user_bloc.dart';
import '../domain/blocs/user/user_state.dart';

UserBloc _userBloc(BuildContext context) => context.bloc<UserBloc>();

class ChoicesComp extends StatelessWidget {
  Row _formInput(String label, Widget input) => Row(
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 10.0), width: 250.0, child: Text(label)),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: input,
            ),
          ),
        ],
      );

  Widget _inputWords(UserBloc userBloc) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: UserState.enteredText(userBloc.state),
        onChanged: (value) => userBloc.add(UpdateChosenValues({'entered_text': value})),
      );

  Widget _inputValidatedNumber(UserBloc userBloc) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () => userBloc.add(UpdateChosenValues({
            'validated_number': (n) => --n,
          })),
        ),
        BlocBuilder<UserBloc, ImmutableModel<UserState>>(
          buildWhen: (previous, current) => UserState.validatedNumber(previous) != UserState.validatedNumber(current),
          builder: (context, model) => Text(UserState.validatedNumber(model).toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () => userBloc.add(UpdateChosenValues({
            'validated_number': (n) => ++n,
          })),
        ),
      ]);

  Widget _inputDouble(UserBloc userBloc) => TextFormField(
      decoration: InputDecoration(border: InputBorder.none),
      initialValue: UserState.enteredDouble(userBloc.state).toStringAsFixed(3),
      onChanged: (value) => userBloc.add(
            UpdateChosenValues({'entered_double': double.parse(value)}),
          ));

  Widget _inputBoolean(UserBloc userBloc) => BlocBuilder<UserBloc, ImmutableModel<UserState>>(
      buildWhen: (previous, current) => UserState.chosenBool(previous) != UserState.chosenBool(current),
      builder: (context, model) => Container(
            child: Checkbox(
              value: UserState.chosenBool(model),
              onChanged: (b) => userBloc.add(UpdateChosenValues({'chosen_bool': b})),
            ),
          ));

  Widget _inputFavSeason(UserBloc userBloc) => BlocBuilder<UserBloc, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous['chosen_values']['chosen_enum'] != current['chosen_values']['chosen_enum'],
        builder: (context, model) => DropdownButton<String>(
          underline: Container(),
          value: UserState.chosenEnum(model),
          onChanged: (String enStr) => userBloc.add(UpdateChosenValues({'chosen_enum': enStr})),
          items: (UserState.chosenValues(model).fieldModel('chosen_enum') as ModelEnum)
              .enumStrings
              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      );

  _selectDateBegin(BuildContext context, DateTime current) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != current) _userBloc(context).add(UpdateChosenValues({'date_begin': picked}));
  }

  Widget _inputDateBegin() => BlocBuilder<UserBloc, ImmutableModel<UserState>>(
        buildWhen: (previous, current) => UserState.dateBegin(previous) != UserState.dateBegin(current),
        builder: (context, model) => Column(
          children: [
            Text(
              "${UserState.dateBegin(model).toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateBegin(context, UserState.dateBegin(model)),
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );

  _selectDateEnd(BuildContext context, DateTime current) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != current) _userBloc(context).add(UpdateChosenValues({'date_end': picked}));
  }

  Widget _inputDateEnd() => BlocBuilder<UserBloc, ImmutableModel<UserState>>(
        buildWhen: (previous, current) => UserState.dateEnd(previous) != UserState.dateEnd(current),
        builder: (context, model) => Column(
          children: [
            Text(
              "${UserState.dateEnd(model).toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateEnd(context, UserState.dateEnd(model)),
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );

  Widget _inputEvensRow(UserBloc userBloc) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: (UserState.listOfEvens(userBloc.state))
            .asMap()
            .entries
            .map((entry) => Flexible(
                  fit: FlexFit.loose,
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    initialValue: entry.value.toString(),
                    onChanged: (value) {
                      userBloc.add(UpdateChosenValues({
                        // if you need a more effecient way of replacing, get the ModelList<> and use the replaceAt function
                        'list_of_evens': (list) {
                          list[entry.key] = int.parse(value);
                          return list;
                        },
                      }));
                    },
                  ),
                ))
            .toList(growable: false),
      );

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.currentState != current.currentState, // only rebuild on state transitions
        builder: (context, state) {
          if (state.currentState is UserUnauthed) {
            return Center(child: Text('User not signed in yet'));
          } else {
            return Column(children: [
              Text("Signed in as - ${_userBloc(context).state['email']}",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _formInput("Enter some text:", _inputWords(_userBloc(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Incriment/decriment (must be >= 0):", _inputValidatedNumber(_userBloc(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Enter a double:", _inputDouble(_userBloc(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a bool:", _inputBoolean(_userBloc(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an enum:", _inputFavSeason(_userBloc(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a beginning date:", _inputDateBegin()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an end date:", _inputDateEnd()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Change list of evens:", _inputEvensRow(_userBloc(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RaisedButton(child: Text("Sort Asc"), onPressed: () => _userBloc(context).sortListAsc()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  // RaisedButton(child: Text("Sort Dec"), onPressed: () => _userBloc(context).sortListDec()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  BlocBuilder<UserBloc, ImmutableModel<UserState>>(
                      buildWhen: (previous, current) =>
                          UserState.listOfEvens(previous) != UserState.listOfEvens(current),
                      builder: (ctx, model) => Text("List total: ${_userBloc(context).listTotal()}")),
                ],
              ),
            ]);
          }
        },
      );
}
