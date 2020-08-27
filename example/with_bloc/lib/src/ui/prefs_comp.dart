import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import 'package:with_bloc/src/domain/cubit/user_cubit.dart';

class PreferancesComp extends StatelessWidget {
  Widget _validatedWord(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: TextField(
          controller: TextEditingController()..text = context.bloc<UserCubit>().state['some_values']['a_str'],
          onChanged: (value) => context.bloc<UserCubit>().updateSomeValues({'a_str': value}),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: "Enter a string",
            border: UnderlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        _validatedWord(context),
      ]),
    );
  }
}
