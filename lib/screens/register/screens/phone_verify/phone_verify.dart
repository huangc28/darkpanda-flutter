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
class RegisterPhoneVerify extends StatefulWidget {
  @override
  _RegisterPhoneVerifyState createState() => _RegisterPhoneVerifyState();
}

class _RegisterPhoneVerifyState extends State<RegisterPhoneVerify> {
  bool _hasSendSMS = false;
  VerifyCodeObject _verifyCodeObj = VerifyCodeObject();

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
                      BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                        listenWhen: (prev, state) {
                          print('DEBUG state ${state.status}');
                          print('DEBUG state ${state.status}');

                          return true;
                        },
                        listener: (context, state) {
                          // listen to SendSMS state. if sms has been send successfully for the first time,
                          // show the buttons to send verify code.
                          print('DEBUG 1 ${state.status}');
                          if (state.status == SendSMSStatus.sendSuccess) {
                            print('DEBUG 2 ${state.sendSMS.verifyPrefix}');
                            setState(() {
                              _setHasSendSMS(true);
                              _setVerifyCodeObject(
                                prefix: state.sendSMS.verifyPrefix,
                                suffix: state.sendSMS.verifySuffix,
                              );
                            });
                          }
                        },
                        child: Container(
                          width: 0,
                          height: 0,
                        ),
                      ),
                      PhoneVerifyForm(
                          hasSendSMS: _hasSendSMS,
                          verifyCodeObj: _verifyCodeObj,
                          onVerify: (models.PhoneVerifyFormModel form) {
                            form.uuid = registerState.user.uuid;
                            _handleVerify(context, form);
                          }),
                    ],
                  )),
        ),
      ),
    );
  }
}
