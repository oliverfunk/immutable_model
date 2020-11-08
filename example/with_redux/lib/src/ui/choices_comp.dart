import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:immutable_model/model_types.dart';

import '../domain/app_state.dart';
import '../domain/redux/user/user_action.dart';
import '../domain/redux/user/user_reducer.dart';
import '../domain/redux/user/user_state.dart';

Store<AppState> _store(BuildContext context) =>
    StoreProvider.of<AppState>(context);

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

  Widget _inputWords(Store<AppState> store) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue:
            store.state.userModel.selectValue(UserState.enteredTextSel),
        onChanged: (value) =>
            store.dispatch(UpdateValues(UserState.enteredTextSel, value)),
      );

  Widget _inputValidatedNumber(Store<AppState> store) => Row(children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          tooltip: 'Decrement',
          onPressed: () => store
              .dispatch(UpdateValues(UserState.validatedNumberSel, (n) => --n)),
        ),
        StoreConnector<AppState, int>(
          converter: (store) =>
              store.state.userModel.selectValue(UserState.validatedNumberSel),
          distinct: true,
          builder: (context, number) => Text(number.toString()),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          tooltip: 'Increment',
          onPressed: () => store
              .dispatch(UpdateValues(UserState.validatedNumberSel, (n) => ++n)),
        ),
      ]);

  Widget _inputDouble(Store<AppState> store) => TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: store.state.userModel
            .selectValue(UserState.enteredDoubleSel)
            .toStringAsFixed(3),
        onChanged: (value) => store.dispatch(
            UpdateValues(UserState.enteredDoubleSel, double.parse(value))),
      );

  Widget _inputBoolean() => StoreConnector<AppState, bool>(
        converter: (store) =>
            store.state.userModel.selectValue(UserState.chosenBoolSel),
        distinct: true,
        builder: (context, bl) => Container(
          child: Checkbox(
              value: bl,
              onChanged: (chosen) => _store(context)
                  .dispatch(UpdateValues(UserState.chosenBoolSel, chosen))),
        ),
      );

  Widget _inputFavSeason() => StoreConnector<AppState, ModelEnum<Seasons>>(
        converter: (store) => store.state.userModel
            .selectModel(UserState.chosenEnumSel) as ModelEnum<Seasons>,
        distinct: true,
        builder: (context, currentSeasonModel) => Row(
          children: [
            DropdownButton<String>(
                underline: Container(),
                value: currentSeasonModel.asString(),
                onChanged: (String enStr) =>
                    _store(context).dispatch(UpdateValues(
                      UserState.chosenEnumSel,
                      currentSeasonModel.nextWithString(enStr),
                    )),
                items: currentSeasonModel.enumStrings
                    .map<DropdownMenuItem<String>>(
                        (String enStr) => DropdownMenuItem<String>(
                              value: enStr,
                              child: Text(enStr),
                            ))
                    .toList()),
            Padding(padding: EdgeInsets.only(left: 2.0)),
            _buildSeasonWords(currentSeasonModel.value),
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
    if (picked != null && picked != current)
      _store(context).dispatch(UpdateValues(UserState.dateBeginSel, picked));
  }

  Widget _inputDateBegin() => StoreConnector<AppState, DateTime>(
        converter: (store) =>
            store.state.userModel.selectValue(UserState.dateBeginSel),
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
      _store(context).dispatch(UpdateValues(UserState.dateEndSel, picked));
  }

  Widget _inputDateEnd() => StoreConnector<AppState, DateTime>(
        converter: (store) =>
            store.state.userModel.selectValue(UserState.dateEndSel),
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                      final ModelIntList intListModel = store.state.userModel
                          .selectModel(UserState.listOfEvensSel);
                      store.dispatch(UpdateValues(
                        UserState.listOfEvensSel,
                        intListModel.replaceAt(
                            entry.key, (_) => int.parse(value)),
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
            final store = _store(context);
            return Column(children: [
              Text(
                "Signed in as - ${store.state.userModel['email']}",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              _formInput(
                "Enter some text:",
                _inputWords(store),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Increment/decrement (must be >= 0):",
                _inputValidatedNumber(store),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Enter a double:",
                _inputDouble(store),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose a bool:",
                _inputBoolean(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _formInput(
                "Choose an enum:",
                _inputFavSeason(),
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
                _inputEvensRow(store),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // RaisedButton(child: Text("Sort Asc"), onPressed: () => _store(context).dispatch(SortListAsc())),
                // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                // RaisedButton(child: Text("Sort Dec"), onPressed: () => _store(context).dispatch(SortListDec())),
                // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                StoreConnector<AppState, List<int>>(
                  converter: (store) => store.state.userModel
                      .selectValue(UserState.listOfEvensSel),
                  distinct: true,
                  builder: (ctx, list) =>
                      Text("List total: ${listTotal(list)}"),
                ),
              ]),
            ]);
          }
        },
      );
}
