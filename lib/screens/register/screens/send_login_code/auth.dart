import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/screens/female/female_app.dart';
import 'package:darkpanda_flutter/screens/male/male_app.dart';

class Auth extends StatefulWidget {
  Auth({this.onPush});

  final ValueChanged<String> onPush;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override

  // If user has already logged in, determine the gender of the user and redirect the user to
  // proper app based on user gender (male / female). stay on this page If not logged.
  void initState() {
    super.initState();

    final authUser = BlocProvider.of<AuthUserBloc>(context).state.user;

    if (authUser != null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(
          context,
          rootNavigator: true,
        ).push(
          MaterialPageRoute(
            builder: (context) =>
                authUser.gender == Gender.female ? FemaleApp() : MaleApp(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Text('auth'),
      ),
    );
  }
}
