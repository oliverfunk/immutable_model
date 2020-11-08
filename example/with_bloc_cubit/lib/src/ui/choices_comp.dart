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
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: 250.0,
              child: Text(label)),
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
        initialValue: userCubit.state.selectValue(UserState.enteredTextSel),
        onChanged: (value) =>
            userCubit.updateValues(UserState.enteredTextSel, value),
      );

  Widget _inputValidatedNumber(UserCubit userCubit) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () =>
              userCubit.updateValues(UserState.validatedNumberSel, (n) => --n),
        ),
        BlocBuilder<UserCubit, ImmutableModel<UserState>>(
          buildWhen: (previous, current) =>
              previous.selectValue(UserState.validatedNumberSel) !=
              current.selectValue(UserState.validatedNumberSel),
          builder: (context, model) =>
              Text(model.selectValue(UserState.validatedNumberSel).toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () =>
              userCubit.updateValues(UserState.validatedNumberSel, (n) => ++n),
        ),
      ]);

  Widget _inputDouble(UserCubit userCubit) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: userCubit.state
            .selectValue(UserState.enteredDoubleSel)
            .toStringAsFixed(3),
        onChanged: (value) => userCubit.updateValues(
            UserState.enteredDoubleSel, double.parse(value)),
      );

  Widget _inputBoolean(UserCubit userCubit) =>
      BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.selectValue(UserState.chosenBoolSel) !=
            current.selectValue(UserState.chosenBoolSel),
        builder: (context, model) => Container(
          child: Checkbox(
              value: model.selectValue(UserState.chosenBoolSel),
              onChanged: (bl) =>
                  userCubit.updateValues(UserState.chosenBoolSel, bl)),
        ),
      );

  Widget _inputFavSeason(UserCubit userCubit) =>
      BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.selectValue(UserState.chosenEnumSel) !=
            current.selectValue(UserState.chosenEnumSel),
        builder: (context, model) {
          final ModelEnum currentSeasonModel =
              model.selectModel(UserState.chosenEnumSel);
          return Row(
            children: [
              DropdownButton<String>(
                  underline: Container(),
                  value: currentSeasonModel.asString(),
                  onChanged: (String enStr) => userCubit.updateValues(
                        UserState.chosenEnumSel,
                        currentSeasonModel.nextWithString(enStr),
                      ),
                  items: currentSeasonModel.enumStrings
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList()),
              Padding(padding: EdgeInsets.only(left: 2.0)),
              _buildSeasonWords(currentSeasonModel.value),
            ],
          );
        },
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
    if (picked != null && picked != current)
      _userCubit(context).updateValues(UserState.dateBeginSel, picked);
  }

  Widget _inputDateBegin() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.selectValue(UserState.dateBeginSel) !=
            current.selectValue(UserState.dateBeginSel),
        builder: (context, model) => Column(
          children: [
            Text(
              "${model.selectValue(UserState.dateBeginSel).toLocal()}"
                  .split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateBegin(
                  context, model.selectValue(UserState.dateBeginSel)),
              child: Text(
                'Select date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
    if (picked != null && picked != current)
      _userCubit(context).updateValues(UserState.dateEndSel, picked);
  }

  Widget _inputDateEnd() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.selectValue(UserState.dateEndSel) !=
            current.selectValue(UserState.dateEndSel),
        builder: (context, model) => Column(
          children: [
            Text(
              "${model.selectValue(UserState.dateEndSel).toLocal()}"
                  .split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateEnd(
                  context, model.selectValue(UserState.dateEndSel)),
              child: Text(
                'Select date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            .selectValue(UserState.listOfEvensSel)
            .asMap()
            .entries
            .map((entry) => Flexible(
                  fit: FlexFit.loose,
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    initialValue: entry.value.toString(),
                    onChanged: (value) {
                      final ModelIntList evensListModel =
                          userCubit.state.selectModel(UserState.listOfEvensSel);
                      userCubit.updateValues(
                        UserState.listOfEvensSel,
                        evensListModel.replaceAt(
                            entry.key, (_) => int.parse(value)),
                      );
                    },
                  ),
                ))
            .toList(growable: false),
      );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous.currentState !=
            current.currentState, // only rebuild on state transitions
        builder: (context, state) {
          if (state.currentState is UserUnauthed) {
            return Center(child: Text('User not signed in yet'));
          } else {
            final userCubit = _userCubit(context);
            return Column(children: [
              Text("Signed in as - ${userCubit.state['email']}",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _formInput(
                "Enter some text:",
                _inputWords(userCubit),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Increment/decrement (must be >= 0):",
                _inputValidatedNumber(userCubit),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Enter a double:",
                _inputDouble(userCubit),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose a bool:",
                _inputBoolean(userCubit),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose an enum:",
                _inputFavSeason(userCubit),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose a beginning date:",
                _inputDateBegin(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose an end date:",
                _inputDateEnd(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Change list of evens:",
                _inputEvensRow(userCubit),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RaisedButton(child: Text("Sort Asc"), onPressed: () => _userCubit(context).sortListAsc()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  // RaisedButton(child: Text("Sort Dec"), onPressed: () => _userCubit(context).sortListDec()),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  BlocBuilder<UserCubit, ImmutableModel<UserState>>(
                      buildWhen: (previous, current) =>
                          previous.selectValue(UserState.listOfEvensSel) !=
                          current.selectValue(UserState.listOfEvensSel),
                      builder: (ctx, model) =>
                          Text("List total: ${userCubit.listTotal()}")),
                ],
              ),
            ]);
          }
        },
      );
}
