import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:immutable_model/model_types.dart';

import 'package:with_redux/src/domain/app_state.dart';
import 'package:with_redux/src/domain/redux/user/user_action.dart';
import 'package:with_redux/src/domain/redux/user/user_reducer.dart';
import 'package:with_redux/src/domain/redux/user/user_state.dart';

Store<AppState> _store(BuildContext context) => StoreProvider.of<AppState>(context);

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

  Widget _inputWords(Store<AppState> store) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: store.state.userModel.select(UserState.enteredTextSel),
        onChanged: (value) => store.dispatch(UpdateValues(UserState.enteredTextSel, value)),
      );

  Widget _inputValidatedNumber(Store<AppState> store) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () => store.dispatch(UpdateValues(UserState.validatedNumberSel, (n) => --n)),
        ),
        StoreConnector<AppState, int>(
          converter: (store) => store.state.userModel.select(UserState.validatedNumberSel),
          distinct: true,
          builder: (context, number) => Text(number.toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () => store.dispatch(UpdateValues(UserState.validatedNumberSel, (n) => ++n)),
        ),
      ]);

  Widget _inputDouble(Store<AppState> store) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: store.state.userModel.select(UserState.enteredDoubleSel).toStringAsFixed(3),
        onChanged: (value) => store.dispatch(UpdateValues(UserState.enteredDoubleSel, double.parse(value))),
      );

  Widget _inputBoolean(Store<AppState> store) => StoreConnector<AppState, bool>(
        converter: (store) => store.state.userModel.select(UserState.chosenBoolSel),
        distinct: true,
        builder: (context, b) => Container(
          child: Checkbox(value: b, onChanged: (bl) => store.dispatch(UpdateValues(UserState.chosenBoolSel, bl))),
        ),
      );

  Widget _inputFavSeason(Store<AppState> store) => StoreConnector<AppState, String>(
        converter: (store) => store.state.userModel.select(UserState.chosenEnumSel),
        distinct: true,
        builder: (context, seasonString) => Row(
          children: [
            DropdownButton<String>(
              underline: Container(),
              value: seasonString,
              onChanged: (String enStr) => store.dispatch(UpdateValues(UserState.chosenEnumSel, enStr)),
              items: (_store(context).state.userModel.selectModel(UserState.chosenEnumSel) as ModelEnum)
                  .enumStrings
                  .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            ),
            Padding(padding: EdgeInsets.only(left: 2.0)),
            _buildSeasonWords(
                (_store(context).state.userModel.selectModel(UserState.chosenEnumSel) as ModelEnum<Seasons>)
                    .valueAsEnum),
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
      case Seasons.Autum:
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
    if (picked != null && picked != current) _store(context).dispatch(UpdateValues(UserState.dateBeginSel, picked));
  }

  Widget _inputDateBegin() => StoreConnector<AppState, DateTime>(
        converter: (store) => store.state.userModel.select(UserState.dateBeginSel),
        distinct: true,
        builder: (context, dtBegin) => Column(
          children: [
            Text(
              "${dtBegin.toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateBegin(context, dtBegin),
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
    if (picked != null && picked != current) _store(context).dispatch(UpdateValues(UserState.dateEndSel, picked));
  }

  Widget _inputDateEnd() => StoreConnector<AppState, DateTime>(
        converter: (store) => store.state.userModel.select(UserState.dateEndSel),
        distinct: true,
        builder: (context, dtEnd) => Column(
          children: [
            Text(
              "${dtEnd.toLocal()}".split(' ')[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _selectDateEnd(context, dtEnd),
              child: Text(
                'Select date',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );

  Widget _inputEvensRow(Store<AppState> store) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: store.state.userModel
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
                      store.dispatch(UpdateValues(
                        UserState.listOfEvensSel,
                        // if you need a more effecient way of replacing, get the ModelList<> and use the replaceAt function
                        (list) {
                          list[entry.key] = int.parse(value);
                          return list;
                        },
                      ));
                    },
                  ),
                ))
            .toList(growable: false),
      );

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userModel.currentState,
        distinct: true,
        builder: (context, state) {
          if (state is UserUnauthed) {
            return Center(child: Text('User not signed in yet'));
          } else {
            return Column(children: [
              Text("Signed in as - ${_store(context).state.userModel['email']}",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _formInput("Enter slistTotalome text:", _inputWords(_store(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Incriment/decriment (must be >= 0):", _inputValidatedNumber(_store(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Enter a double:", _inputDouble(_store(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a bool:", _inputBoolean(_store(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an enum:", _inputFavSeason(_store(context))),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose a beginning date:", _inputDateBegin()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Choose an end date:", _inputDateEnd()),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput("Change list of evens:", _inputEvensRow(_store(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RaisedButton(child: Text("Sort Asc"), onPressed: () => _store(context).dispatch(SortListAsc())),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  // RaisedButton(child: Text("Sort Dec"), onPressed: () => _store(context).dispatch(SortListDec())),
                  // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                  StoreConnector<AppState, List<int>>(
                      converter: (store) => store.state.userModel.select(UserState.listOfEvensSel),
                      distinct: true,
                      builder: (ctx, list) => Text("List total: ${listTotal(list)}")),
                ],
              ),
            ]);
          }
        },
      );
}
