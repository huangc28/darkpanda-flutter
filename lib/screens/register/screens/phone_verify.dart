import 'package:flutter/material.dart';

import './phone_verify_form.dart';

// @TODO:
//   - Create a phone number form field
//   - Create a verify code form field
class RegisterPhoneVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 120.0,
            horizontal: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PhoneVerifyForm(),
            ],
          ),
        ),
      ),
    );
  }
}
