import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/screens/login/login.dart';
import 'package:darkpanda_flutter/screens/register/register.dart';
//import 'package:darkpanda_flutter/screens/home.dart';

// import 'package:darkpanda_flutter/screens/examples/bloc/main.dart';

void main() => runApp(DarkPandaApp());

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/register',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),

        // The following routes are example flutter code.
        // '/bloc-example': (context) => MainScreen(),
      },
    );
  }
}
