import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/app.dart';

import './components/login_form.dart';
import '../../bloc/send_login_verify_code_bloc.dart';

// TODOs:
//   - Add a button to redirect user to register page.
class Auth extends StatefulWidget {
  Auth({this.onPush});

  final ValueChanged<String> onPush;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override

  /// If user has already logged in, navigate to `/app` route.
  /// If not,  stay on this page and ask  user to `login` / `register`.
  void initState() {
    final authUser = BlocProvider.of<AuthUserBloc>(context).state.user;

    if (authUser != null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(
          context,
          rootNavigator: true,
        ).push(
          MaterialPageRoute(
            builder: (context) => App(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',
            style: TextStyle(
              color: Colors.black,
            )),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
        listener: (context, state) {
          // Display snack bar if error occured.
          if (state.status == SendLoginVerifyCodeStatus.sendFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          }

          // Redirect to verify code page, if verify code is send successfully.
          if (state.status == SendLoginVerifyCodeStatus.sendSuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('success'),
              ),
            );

            widget.onPush('/verify-login-code');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: LoginForm(
                    onPressRegister: _handlePressRegister,
                    onSendVerifyCode: _handleSendVerifyCode,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendVerifyCode(String username) {
    // emit send login verify code event.
    BlocProvider.of<SendLoginVerifyCodeBloc>(context).add(SendLoginVerifyCode(
      username: username,
    ));
  }

  void _handlePressRegister() {
    widget.onPush('/register');
    print('DEBUG trigger press register');
  }
}
