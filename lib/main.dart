import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './screens/login/login.dart';
import './screens/register/register.dart' as RegisterScreen;

void main() => runApp(DarkPandaApp());

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/register',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => BlocProvider(
              create: (context) => RegisterBloc(RegisterRepository()),
              child: RegisterScreen.Register(),
            ),

        // The following routes are example flutter code.
        // '/bloc-example': (context) => MainScreen(),
      },
    );
  }
}
