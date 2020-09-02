import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/model_types.dart';
import 'package:with_bloc/src/domain/cubit/user_cubit.dart';
import 'package:with_bloc/src/domain/models/user_state.dart';

class PreferancesComp extends StatelessWidget {
  UserCubit _userCubit(BuildContext context) => context.bloc<UserCubit>();

  Widget _inputWord(UserCubit userCubit) => TextFormField(
        initialValue: userCubit.someValues['words'],
        onChanged: (value) => userCubit.updateSomeValues({'words': value}),
        decoration: InputDecoration(
          hintText: "Enter some words",
          border: UnderlineInputBorder(),
        ),
      );

// validated_number"
// a_double": M.dbl(
// this_is_great": M
// favourite_season"
// date_begin": M.dt imnasms
// date_end": M.dt(i
// list_of_evens': M

  Widget _inputValidatedNumber(UserCubit userCubit) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(children: [
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
                previous['some_values']['validated_number'] != current['some_values']['validated_number'],
            builder: (context, model) => Text(userCubit.someValues['validated_number'].toString()),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up),
            tooltip: 'Increment',
            onPressed: () => userCubit.updateSomeValues({
              'validated_number': (n) => ++n,
            }),
          ),
        ]),
      );

  Widget _inputDouble(UserCubit userCubit) => TextFormField(
      initialValue: userCubit.someValues['a_double'].toStringAsFixed(3),
      onChanged: (value) => userCubit.updateSomeValues({'a_double': double.parse(value)}),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter a double",
        border: UnderlineInputBorder(),
      ));

  Widget _inputBoolean(UserCubit userCubit) => Row(
        children: [
          Text("Is this great?"),
          BlocBuilder<UserCubit, ImmutableModel<UserState>>(
            buildWhen: (previous, current) =>
                previous['some_values']['this_is_great'] != current['some_values']['this_is_great'],
            builder: (context, model) => Checkbox(
                value: userCubit.someValues['this_is_great'],
                onChanged: (b) => userCubit.updateSomeValues({'this_is_great': b})),
          ),
        ],
      );

  Widget _inputFavSeason(UserCubit userCubit) => BlocBuilder<UserCubit, ImmutableModel<UserState>>(
        buildWhen: (previous, current) =>
            previous['some_values']['favourite_season'] != current['some_values']['favourite_season'],
        builder: (context, model) => DropdownButton<String>(
          value: userCubit.someValues['favourite_season'],
          icon: Icon(Icons.keyboard_arrow_down, size: 20.0),
          style: TextStyle(color: Colors.deepPurple),
          onChanged: (String newValue) => userCubit.updateSomeValues({'favourite_season': newValue}),
          items: (userCubit.someValues.fieldModel('favourite_season') as ModelEnum)
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

  Widget _inputDates(BuildContext context, UserCubit userCubit) => Row(children: [
        Column(children: <Widget>[
          Text("Select a beginning date"),
          BlocBuilder<UserCubit, ImmutableModel<UserState>>(
            buildWhen: (previous, current) =>
                previous['some_values']['date_begin'] != current['some_values']['date_begin'],
            builder: (context, state) => Text(
              "${userCubit.someValues['date_begin'].toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () => _selectDateBegin(context, userCubit),
            child: Text(
              'Select beginning date',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            color: Colors.greenAccent,
          ),
        ]),
        Padding(padding: EdgeInsets.all(10.0)),
        Column(children: <Widget>[
          Text("Select an end date"),
          BlocBuilder<UserCubit, ImmutableModel<UserState>>(
            buildWhen: (previous, current) => previous['some_values']['date_end'] != current['some_values']['date_end'],
            builder: (context, state) => Text(
              "${userCubit.someValues['date_end'].toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () => _selectDateEnd(context, userCubit),
            child: Text(
              'Select end date',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            color: Colors.greenAccent,
          ),
        ]),
      ]);

  Widget _inputEvensRow(UserCubit userCubit) => Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: (userCubit.someValues['list_of_evens'] as List<int>)
          .asMap()
          .entries
          .map((entry) => Flexible(
                fit: FlexFit.loose,
                child: TextFormField(
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
// todo: show them undo0o
  @override
  Widget build(BuildContext context) => Container(
        child: Column(children: [
          _inputWord(_userCubit(context)),
          _inputValidatedNumber(_userCubit(context)),
          _inputDouble(_userCubit(context)),
          _inputBoolean(_userCubit(context)),
          _inputFavSeason(_userCubit(context)),
          _inputDates(context, _userCubit(context)),
          _inputEvensRow(_userCubit(context)),
        ]),
      );
}
