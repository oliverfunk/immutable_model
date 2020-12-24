import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immutable_model/immutable_model.dart';

import '../domain/cubits/auth_cubit.dart';

class SignInComponent extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final email = context.select((AuthCubit ac) => ac.state.email);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            key: _emailKey,
            initialValue: email.value ?? '',
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.portrait, color: Colors.grey),
              hintText: 'Enter your email',
            ),
            validator: (value) =>
                ModelEmail.validator(value!) ? null : 'Enter a valid email',
          ),
          TextFormField(
            key: _passwordKey,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
              hintText: 'Enter an example password',
            ),
            validator: (value) => ModelPassword.validator(value!)
                ? null
                : 'Enter a password that is at least 8 characters long, has one upper case and one lower case letter and one number',
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthCubit>().signIn(
                      ModelEmail(_emailKey.currentState!.value),
                      ModelPassword(_passwordKey.currentState!.value),
                    );
              }
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
