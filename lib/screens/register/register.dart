import 'package:flutter/material.dart';

import 'register_form.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 150.0, horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: RegisterForm(),
            ),
          ],
        ),
      ),
    );
  }
}
