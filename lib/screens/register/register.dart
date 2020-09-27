import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './components/register_form.dart';
import './models/models.dart' as models;
import './bloc/register_bloc.dart' as registerBloc;

class Register extends StatelessWidget {
  void _handleRegister(BuildContext context, models.RegisterForm form) {
    BlocProvider.of<RegisterBloc>(context).add(registerBloc.Register(
      username: form.username,
      gender: form.gender,
      referalcode: form.referalCode,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 120.0, horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: BlocListener<RegisterBloc, RegisterState>(
                  listener: (BuildContext context, state) {
                    if (state.status == RegisterStatus.registered) {
                      // navigate to phone verify page.
                      print('Navigating to /register/verify-phone ...');
                      Navigator.pushNamed(
                        context,
                        '/register/verify-phone',
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
}
