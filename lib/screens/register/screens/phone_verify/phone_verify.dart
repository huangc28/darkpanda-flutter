import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phone_verify_form.dart';
import '../bloc/send_sms_code_bloc.dart';
import '../models/phone_verify_form.dart' as models;

// @TODO:
//   - Create a phone number form field [ok]
//   - Create a verify code form field [ok]
//   - Send verify code via SMS [ok]
//   - Control the display of `Send`, `ReSend` && `Verify` button of verify form widget
//     from here.
class RegisterPhoneVerify extends StatelessWidget {
  /// New user uuid to send to the API alone with other request payload
  void _handleVerify(BuildContext context, models.PhoneVerifyFormModel form) {
    BlocProvider.of<SendSmsCodeBloc>(context).add(SendSMSCode(
      countryCode: form.countryCode,
      mobileNumber: form.mobileNumber,
      uuid: form.uuid,
    ));
  }

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
              BlocBuilder<RegisterBloc, RegisterState>(
                  cubit: BlocProvider.of<RegisterBloc>(context),
                  builder: (context, state) {
                    // if send sms success, display verify phone widget.
                    return PhoneVerifyForm(
                        onVerify: (models.PhoneVerifyFormModel form) {
                      form.uuid = state.user.uuid;
                      _handleVerify(context, form);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
