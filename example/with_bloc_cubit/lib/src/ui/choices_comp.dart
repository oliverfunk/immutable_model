import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../domain/cubits/user_cubit.dart';
import '../domain/models/user_state.dart';

UserCubit _userCubit(BuildContext context) => context.bloc<UserCubit>();

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

  Widget _inputWords(UserCubit userCubit) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: userCubit.state.select(UserState.enteredTextSel),
        onChanged: (value) => userCubit.updateValues(UserState.enteredTextSel, value),
      );

  Widget _inputValidatedNumber(UserCubit userCubit) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () => userCubit.updateValues(UserState.validatedNumberSel, (n) => --n),
        ),
        BlocBuilder<UserCubit, ImmutableModel<UserState>>(
          buildWhen: (previous, current) =>
              previous.select(UserState.validatedNumberSel) != current.select(UserState.validatedNumberSel),
          builder: (context, model) => Text(model.select(UserState.validatedNumberSel).toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () => userCubit.updateValues(UserState.validatedNumberSel, (n) => ++n),
        ),
      ]);

  Widget _inputDouble(UserCubit userCubit) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: userCubit.state.select(UserState.enteredDoubleSel).toStringAsFixed(3),
        onChanged: (value) => userCubit.updateValues(UserState.enteredDoubleSel, double.parse(value)),
      );

  Widget _inputBoolean(UserCubit userCubit) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.select(UserState.chosenBoolSel) != current.select(UserState.chosenBoolSel),
        builder: (context, model) => Container(
          child: Checkbox(
              value: model.select(UserState.chosenBoolSel),
              onChanged: (bl) => userCubit.updateValues(UserState.chosenBoolSel, bl)),
        ),
      );

  Widget _inputFavSeason(UserCubit userCubit) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.select(UserState.chosenEnumSel) != current.select(UserState.chosenEnumSel),
        builder: (context, model) => Row(
          children: [
            DropdownButton<String>(
              underline: Container(),
              value: model.select(UserState.chosenEnumSel),
              onChanged: (String enStr) => userCubit.updateValues(UserState.chosenEnumSel, enStr),
              items: (model.selectModel(UserState.chosenEnumSel) as ModelEnum)
                  .enumStrings
                  .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            ),
            Padding(padding: EdgeInsets.only(left: 2.0)),
            _buildSeasonWords((model.selectModel(UserState.chosenEnumSel) as ModelEnum<Seasons>).valueAsEnum),
          ],
        ),
      );

  // ignore: missing_return
  Widget _buildSeasonWords(Seasons current) {
    switch (current) {
      case Seasons.Spring:
        return Text("has sprung.");
        break;
      case Seasons.Summer:
        return Text("time sunshine.");
        break;
      case Seasons.Winter:
        return Text("is coming.");
        break;
      case Seasons.Autumn:
        return Text("leaves on the trees.");
        break;
    }
  }

  _selectDateBegin(BuildContext context, DateTime current) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != current) _userCubit(context).updateValues(UserState.dateBeginSel, picked);
  }

  Widget _inputDateBegin() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.select(UserState.dateBeginSel) != current.select(UserState.dateBeginSel),
        builder: (context, model) => Column(
          children: [
            Text(
              "${model.select(UserState.dateBeginSel).toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateBegin(context, model.select(UserState.dateBeginSel)),
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
    if (picked != null && picked != current) _userCubit(context).updateValues(UserState.dateEndSel, picked);
  }

  Widget _inputDateEnd() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) => previous.select(UserState.dateEndSel) != current.select(UserState.dateEndSel),
        builder: (context, model) => Column(
          children: [
            Text(
              "${model.select(UserState.dateEndSel).toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateEnd(context, model.select(UserState.dateEndSel)),
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );

  Widget _inputEvensRow(UserCubit userCubit) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: userCubit.state
            .select(UserState.listOfEvensSel)
            .asMap()
            .entries
            .map((entry) => Flexible(
                  fit: FlexFit.loose,
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    initialValue: entry.value.toString(),
                    onChanged: (value) {
                      userCubit.updateValues(
                        UserState.listOfEvensSel,
                        // if you need a more efficient way of replacing, get the ModelList<> and use the replaceAt function
                        (list) {
                          list[entry.key] = int.parse(value);
                          return list;
                        },
                      );
                    },
                  ),
                ))
            .toList(growable: false),
      );

  @override
  Widget build(BuildContext context) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.currentState != current.currentState, // only rebuild on state transitions
        builder: (context, state) {
          if (state.currentState is UserUnauthed) {
            return Center(child: Text('User not signed in yet'));
          } else {
            return Column(children: [
              Text("Signed in as - ${_userCubit(context).state['email']}",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _formInput("Enter some text:", _inputWords(_userCubit(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Increment/decrement (must be >= 0):", _inputValidatedNumber(_userCubit(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Enter a double:", _inputDouble(_userCubit(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a bool:", _inputBoolean(_userCubit(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an enum:", _inputFavSeason(_userCubit(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a beginning date:", _inputDateBegin()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an end date:", _inputDateEnd()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Change list of evens:", _inputEvensRow(_userCubit(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RaisedButton(child: Text("Sort Asc"), onPressed: () => _userCubit(context).sortListAsc()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  // RaisedButton(child: Text("Sort Dec"), onPressed: () => _userCubit(context).sortListDec()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  BlocBuilder<UserCubit, ImmutableModel<UserState>>(
                      buildWhen: (previous, current) =>
                          previous.select(UserState.listOfEvensSel) != current.select(UserState.listOfEvensSel),
                      builder: (ctx, model) => Text("List total: ${_userCubit(context).listTotal()}")),
                ],
              ),
            ]);
          }
        },
      );
}
