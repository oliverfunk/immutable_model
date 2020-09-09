import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';

import '../domain/cubit/user_cubit.dart';
import '../domain/models/user_state.dart';

UserCubit _userCubit(BuildContext context) => context.bloc<UserCubit>();

class PreferancesComp extends StatelessWidget {
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
        initialValue: userCubit.someValues['entered_text'],
        onChanged: (value) => userCubit.updateSomeValues({'entered_text': value}),
      );

  Widget _inputValidatedNumber(UserCubit userCubit) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () => userCubit.updateSomeValues({
            'validated_number': (n) => --n,
          }),
        ),
        BlocBuilder<UserCubit, ImmutableModel<UserState>>(
          buildWhen: (previous, current) =>
              previous['chosen_values']['validated_number'] != current['chosen_values']['validated_number'],
          builder: (context, model) => Text(userCubit.someValues['validated_number'].toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () => userCubit.updateSomeValues({
            'validated_number': (n) => ++n,
          }),
        ),
      ]);

  Widget _inputDouble(UserCubit userCubit) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: userCubit.someValues['entered_double'].toStringAsFixed(3),
        onChanged: (value) => userCubit.updateSomeValues({'entered_double': double.parse(value)}),
      );

  Widget _inputBoolean(UserCubit userCubit) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous['chosen_values']['chosen_bool'] != current['chosen_values']['chosen_bool'],
        builder: (context, model) => Container(
          child: Checkbox(
              value: userCubit.someValues['chosen_bool'],
              onChanged: (b) => userCubit.updateSomeValues({'chosen_bool': b})),
        ),
      );

  Widget _inputFavSeason(UserCubit userCubit) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous['chosen_values']['chosen_enum'] != current['chosen_values']['chosen_enum'],
        builder: (context, model) => DropdownButton<String>(
          underline: Container(),
          value: userCubit.someValues['chosen_enum'],
          onChanged: (String newValue) => userCubit.updateSomeValues({'chosen_enum': newValue}),
          items: (userCubit.someValues.fieldModel('chosen_enum') as ModelEnum)
              .enumStrings
              .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      );

  _selectDateBegin(BuildContext context, UserCubit userCubit) async {
    final selectedDate = userCubit.someValues['date_begin'];
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) userCubit.updateSomeValues({'date_begin': picked});
  }

  Widget _inputDateBegin() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous['chosen_values']['date_begin'] != current['chosen_values']['date_begin'],
        builder: (context, state) => Column(
          children: [
            Text(
              "${_userCubit(context).someValues['date_begin'].toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateBegin(context, _userCubit(context)),
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );

  _selectDateEnd(BuildContext context, UserCubit userCubit) async {
    final selectedDate = userCubit.someValues['date_end'];
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) userCubit.updateSomeValues({'date_end': picked});
  }

  Widget _inputDateEnd() => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) => previous['chosen_values']['date_end'] != current['chosen_values']['date_end'],
        builder: (context, state) => Column(
          children: [
            Text(
              "${_userCubit(context).someValues['date_end'].toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateEnd(context, _userCubit(context)),
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
      children: (userCubit.someValues['list_of_evens'] as List<int>)
          .asMap()
          .entries
          .map((entry) => Flexible(
                fit: FlexFit.loose,
                child: TextFormField(
                  decoration: InputDecoration(border: InputBorder.none),
                  textAlign: TextAlign.center,
                  initialValue: entry.value.toString(),
                  onChanged: (value) {
                    userCubit.updateSomeValues({
                      'list_of_evens': (userCubit.someValues.fieldModel('list_of_evens') as ModelList<int>)
                          .replaceAt(entry.key, int.parse(value))
                    });
                  },
                ),
              ))
          .toList(growable: false));

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
              _formInput("Incriment/decriment (must be >= 0):", _inputValidatedNumber(_userCubit(context))),
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
            ]);
          }
        },
      );
}
