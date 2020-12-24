import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/cubits/user_cubit.dart';
import '../domain/models/user_model.dart';

class ChoicesComp extends StatelessWidget {
  Row _labelledInput(
    String label, {
    required Widget widget,
  }) =>
      Row(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: 250.0,
              child: Text(label)),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => BlocBuilder<UserCubit, UserModel>(
        buildWhen: (previous, current) =>
            previous.currentState !=
            current.currentState, // only rebuild on state transitions
        builder: (context, model) {
          if (model.currentState is UserUnauthed) {
            return Center(child: Text('User not signed in yet'));
          } else {
            return Column(children: [
              Text("Signed in as - ${model.email}",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              _labelledInput(
                "Enter some text:",
                widget: InputValidText(
                  initialValue: model.enteredText.value!,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Increment/decrement (must be >= 0):",
                widget: InputValidInteger(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Enter a double:",
                widget: InputValidDouble(
                  initialValue: model.enteredDouble.value!,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Choose a bool:",
                widget: InputValidBool(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Choose an enum:",
                widget: InputValidEnum(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Choose a beginning date:",
                widget: InputValidDateBegin(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Choose an end date:",
                widget: InputValidDateEnd(),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _labelledInput(
                "Change list of evens:",
                widget: InputValidList(),
              ),
            ]);
          }
        },
      );
}

class InputValidList extends StatelessWidget {
  const InputValidList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vlist = context.select((UserCubit uc) => uc.state.listOfEvens);

    return Column(
      children: [
        Row(
          key: UniqueKey(),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: vlist.value
              .asMap()
              .entries
              .map(
                (entry) => Flexible(
                  fit: FlexFit.loose,
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    initialValue: entry.value.toString(),
                    onChanged: (value) {
                      context.read<UserCubit>().updateValue(
                            vlist,
                            vlist.replaceAt(
                              entry.key,
                              (_) => int.parse(value),
                            ),
                          );
                    },
                  ),
                ),
              )
              .toList(growable: false),
        ),
        Text("List total: ${UserCubit.listTotal(vlist.value)}"),
        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                child: Text("Sort Asc"),
                onPressed: () => context.read<UserCubit>().sortListAsc()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
            RaisedButton(
                child: Text("Sort Dec"),
                onPressed: () => context.read<UserCubit>().sortListDec()),
          ],
        ),
      ],
    );
  }
}

class InputValidDateEnd extends StatelessWidget {
  const InputValidDateEnd({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vdtend = context.select((UserCubit uc) => uc.state.dateEnd);

    return Column(
      children: [
        Text(
          "${vdtend.value!.toLocal()}".split(' ')[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RaisedButton(
          padding: EdgeInsets.all(10.0),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: vdtend.value!,
              firstDate: DateTime(2000),
              lastDate: DateTime(2025),
            );
            if (picked != null && picked != vdtend.value!) {
              context.read<UserCubit>().updateValue(
                    vdtend,
                    picked,
                  );
            }
          },
          child: Text(
            'Select date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          color: Colors.greenAccent,
        ),
      ],
    );
  }
}

class InputValidDateBegin extends StatelessWidget {
  const InputValidDateBegin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vdtbeg = context.select((UserCubit uc) => uc.state.dateBegin);

    return Column(
      children: [
        Text(
          "${vdtbeg.value!.toLocal()}".split(' ')[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RaisedButton(
          padding: EdgeInsets.all(10.0),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: vdtbeg.value!,
              firstDate: DateTime(2000),
              lastDate: DateTime(2025),
            );
            if (picked != null && picked != vdtbeg.value!) {
              context.read<UserCubit>().updateValue(
                    vdtbeg,
                    picked,
                  );
            }
          },
          child: Text(
            'Select date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          color: Colors.greenAccent,
        ),
      ],
    );
  }
}

class InputValidEnum extends StatelessWidget {
  const InputValidEnum({
    Key? key,
  }) : super(key: key);

  // ignore: missing_return
  Widget _buildSeasonWords(Seasons current) {
    switch (current) {
      case Seasons.Spring:
        return Text("has sprung.");
      case Seasons.Summer:
        return Text("time sunshine.");
      case Seasons.Winter:
        return Text("is coming.");
      case Seasons.Autumn:
        return Text("leaves on the trees.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final venum = context.select((UserCubit uc) => uc.state.chosenEnum);

    return Row(
      children: [
        DropdownButton<String>(
            underline: Container(),
            value: venum.asString(),
            onChanged: (String? enStr) {
              if (enStr == null) return;
              context.read<UserCubit>().updateValue(
                    venum,
                    context
                        .read<UserCubit>()
                        .state
                        .chosenEnum
                        .nextWithString(enStr),
                  );
            },
            items: venum.enumStrings
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                .toList()),
        Padding(padding: EdgeInsets.only(left: 2.0)),
        _buildSeasonWords(venum.value),
      ],
    );
  }
}

class InputValidBool extends StatelessWidget {
  const InputValidBool({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vbool = context.select((UserCubit uc) => uc.state.chosenBool);

    return Container(
      child: Checkbox(
        value: vbool.value!,
        onChanged: (bl) => context
            .read<UserCubit>()
            .updateValue(context.read<UserCubit>().state.chosenBool, bl),
      ),
    );
  }
}

class InputValidDouble extends StatelessWidget {
  final double initialValue;

  const InputValidDouble({
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(border: InputBorder.none),
      initialValue: initialValue.toStringAsFixed(3),
      onChanged: (value) => context.read<UserCubit>().updateValue(
            context.read<UserCubit>().state.enteredDouble,
            double.parse(value),
          ),
    );
  }
}

class InputValidInteger extends StatelessWidget {
  const InputValidInteger({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vint = context.select((UserCubit uc) => uc.state.validatedNumber);

    return Row(children: [
      IconButton(
        icon: Icon(
          Icons.keyboard_arrow_down,
        ),
        tooltip: 'Decrement',
        onPressed: () => context.read<UserCubit>().updateValue(
              context.read<UserCubit>().state.validatedNumber,
              (int n) => --n,
            ),
      ),
      Text(
        vint.value.toString(),
      ),
      IconButton(
        icon: Icon(Icons.keyboard_arrow_up),
        tooltip: 'Increment',
        onPressed: () => context.read<UserCubit>().updateValue(
              context.read<UserCubit>().state.validatedNumber,
              (int n) => ++n,
            ),
      ),
    ]);
  }
}

class InputValidText extends StatelessWidget {
  final String initialValue;

  const InputValidText({
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(border: InputBorder.none),
      initialValue: initialValue,
      onChanged: (value) => context.read<UserCubit>().updateValue(
            context.read<UserCubit>().state.enteredText,
            value,
          ),
    );
  }
}
