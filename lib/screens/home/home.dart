import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/layouts/logo.dart' as LoginLayout;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginLayout.LogoLayout(
        body: LoginBtnContainer(),
      ),
    );
  }
}

class LoginBtnContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ButtonTheme(
          minWidth: 200.0,
          height: 50.0,
          child: OutlineButton(
              child: Text('Login'),
              onPressed: () {
                print('DEBUG trigger login');
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0))),
        ),
        SizedBox(height: 20),
        ButtonTheme(
          minWidth: 200.0,
          height: 50.0,
          child: OutlineButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0))),
        ),
      ],
    );
  }
}
