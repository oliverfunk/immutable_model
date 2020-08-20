import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/value_types.dart';

import '../domain/cubit/auth_cubit.dart';

class LoginComponent extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  Widget _emailInput(BuildContext context) => TextFormField(
        key: _emailKey,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.portrait, color: Colors.grey),
          hintText: 'Enter your email',
        ),
        validator: (value) => ModelEmail.validator(value) ? null : 'Enter a valid email',
      );

  Widget _passwordInput(BuildContext context) => TextFormField(
        key: _passwordKey,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
          hintText: 'Enter a password',
        ),
        validator: (value) => ModelPassword.validator(value)
            ? null
            : 'Enter a password that is at least 8 characters long, has one upper case and one lower case letter and one number',
      );

  // BlocBuilder<UserCubit, ImmutableModel>(
  //       buildWhen: (previous, current) => previous['email'] != current['email'],
  //       builder: (_, model) =>
  //     );

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _emailInput(context),
            _passwordInput(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.bloc<AuthCubit>().signIn(
                          ModelEmail(_emailKey.currentState.value),
                          ModelPassword(_passwordKey.currentState.value),
                        );
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      );
}
