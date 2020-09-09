import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import 'phone_verify_form.dart';
import '../bloc/send_sms_code_bloc.dart';
import '../models/phone_verify_form.dart' as models;

// @TODO:
//   - Create a phone number form field [ok]
//   - Create a verify code form field [ok]
//   - Send verify code via SMS [ok]
//   - Control the display of `Send`, `ReSend` && `Verify` button of verify form widget
//     from here.
class RegisterPhoneVerify extends StatefulWidget {
  @override
  _RegisterPhoneVerifyState createState() => _RegisterPhoneVerifyState();
}

class _RegisterPhoneVerifyState<Error extends AppBaseException>
    extends State<RegisterPhoneVerify> {
  bool _hasSendSMS = false;
  VerifyCodeObject _verifyCodeObj = VerifyCodeObject();

  // Error object to pass to `phone_verify_form` for displaying error message
  // when failed to verify mobile.
  Error _verifyCodeError;

  /// New user uuid to send to the API alone with other request payload
  void _handleVerify(BuildContext context, models.PhoneVerifyFormModel form) {
    BlocProvider.of<SendSmsCodeBloc>(context).add(SendSMSCode(
      countryCode: form.countryCode,
      mobileNumber: form.mobileNumber,
      uuid: form.uuid,
    ));
  }

  void _setHasSendSMS(bool show) {
    _hasSendSMS = show;
  }

  void _setVerifyCodeObject({String prefix, int suffix}) {
    _verifyCodeObj.prefix = prefix;
    _verifyCodeObj.suffix = suffix;
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
          child: BlocBuilder<RegisterBloc, RegisterState>(
              cubit: BlocProvider.of<RegisterBloc>(context),
              builder: (context, registerState) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      BlocConsumer<SendSmsCodeBloc, SendSmsCodeState>(
                        listener: (context, state) {
                          // listen to SendSMS state. if sms has been send successfully for the first time,
                          // show the buttons to send verify code.
                          if (state.status == SendSMSStatus.sendSuccess) {
                            setState(() {
                              _setHasSendSMS(true);
                              _setVerifyCodeObject(
                                prefix: state.sendSMS.verifyPrefix,
                                suffix: state.sendSMS.verifySuffix,
                              );
                            });
                          }

                          // if send SMS failed, we should display error message in PhoneVerifyForm.
                          if (state.status == SendSMSStatus.sendFailed) {
                            setState(() {
                              _verifyCodeError = state.error;
                            });
                          }
                        },
                        builder: (context, state) {
                          return PhoneVerifyForm(
                              hasSendSMS: _hasSendSMS,
                              verifyCodeObj: _verifyCodeObj,
                              verifyCodeError: _verifyCodeError,
                              onSendSMS: () {
                                print('DEBUG onSendSMS');
                              },
                              onVerify: (models.PhoneVerifyFormModel form) {
                                form.uuid = registerState.user.uuid;
                                _handleVerify(context, form);
                              });
                        },
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
