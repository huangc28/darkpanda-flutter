import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/register_bloc.dart';
import './components/register_form.dart';
import './models/models.dart' as models;
import './bloc/register_bloc.dart' as registerBloc;

class Register extends StatelessWidget {
  const Register({this.onPush});

  final ValueChanged<String> onPush;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: BlocListener<RegisterBloc, RegisterState>(
                  listener: (BuildContext context, state) {
                    if (state.status == RegisterStatus.registered) {
                      // navigate to phone verify page.
                      print('Navigating to /register/verify-phone ...');
                      onPush('/register/verify-phone');
                    }

                    if (state.status == RegisterStatus.registerFailed) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error.message),
                        ),
                      );
                    }
                  },
                  child: RegisterForm(
                      onRegister: (models.RegisterForm form) =>
                          _handleRegister(context, form)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister(BuildContext context, models.RegisterForm form) {
    BlocProvider.of<RegisterBloc>(context).add(registerBloc.Register(
      username: form.username,
      gender: form.gender,
      referalcode: form.referalCode,
    ));
  }
}
