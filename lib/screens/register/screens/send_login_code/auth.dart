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
      print('DEBUG ${authUser.gender}');

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
      // body: BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
      //   listener: (context, state) {
      //     // Display snack bar if error occured.
      //     if (state.status == SendLoginVerifyCodeStatus.sendFailed) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //           content: Text(state.error.message),
      //         ),
      //       );
      //     }

      //     // Redirect to verify code page, if verify code is send successfully.
      //     if (state.status == SendLoginVerifyCodeStatus.sendSuccess) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //           content: Text('success'),
      //         ),
      //       );

      //       widget.onPush('/verify-login-code');
      //     }
      //   },
      //   child: SafeArea(
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      //             child: LoginForm(
      //               onPressRegister: _handlePressRegister,
      //               onSendVerifyCode: _handleSendVerifyCode,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void _handleSendVerifyCode(String username) {
    // emit send login verify code event.
    // BlocProvider.of<SendLoginVerifyCodeBloc>(context).add(SendLoginVerifyCode(
    //   username: username,
    // ));
  }

  void _handlePressRegister() {
    widget.onPush('/register');
    print('DEBUG trigger press register');
  }
}
