import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import 'components/send_phone_verify_code.dart';
import 'bloc/send_sms_code_bloc.dart';
import 'models/phone_verify_form.dart' as models;
import '../../bloc/register_bloc.dart';

// @TODO:
//   - Create a phone number form field [ok]
//   - Create a verify code form field [ok]
//   - Send verify code via SMS [ok]
//   - Control the display of `Send`, `ReSend` && `Verify` button of verify form widget
//     from here. [ok]
//   - Implement resend button and functionality [ok]
//   - set a timer on every resend.
//     1. User is able to send SMS 4 times.
//     2. Each resend increases the waiting time by 30 seconds, 30, 60, 90, 120...
//     3. After the forth resend, the server would lock the user to further sends the SMS. After 24 hours, backend would
//        unlock the user.
//   - Redirect user to appropriate index page according to gender
class SendRegisterVerifyCode extends StatefulWidget {
  const SendRegisterVerifyCode({this.onPush});

  final Function onPush;

  @override
  _SendRegisterVerifyCodeState createState() => _SendRegisterVerifyCodeState();
}

class _SendRegisterVerifyCodeState<Error extends AppBaseException>
    extends State<SendRegisterVerifyCode> {
  String _mobileNumber;

  String _countryCode;

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
                      MultiBlocListener(
                        listeners: [
                          BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                            listener: (context, state) {
                              if (state.status == SendSMSStatus.sending) {}

                              if (state.status == SendSMSStatus.sendSuccess) {
                                // redirect to next page to verify phone.
                                widget.onPush(
                                  '/register/verify-register-code',
                                  {
                                    'country_code': _countryCode,
                                    'mobile': _mobileNumber,
                                    'verify_chars': state.sendSMS.verifyPrefix,
                                    'uuid': state.sendSMS.uuid,
                                  },
                                );
                              }

                              // if send SMS failed, we should display error message in PhoneVerifyForm.
                              if (state.status == SendSMSStatus.sendFailed) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error.message),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        child: SendPhoneVerifyCode(
                          onSend: (models.PhoneVerifyFormModel form) {
                            form.uuid = registerState.user.uuid;
                            _handleSendSMS(form);
                          },
                        ),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }

  /// Emit event to send SMS verify code.
  void _handleSendSMS(models.PhoneVerifyFormModel form) {
    setState(() {
      _mobileNumber = form.mobileNumber;
      _countryCode = form.countryCode;
    });

    BlocProvider.of<SendSmsCodeBloc>(context).add(
      SendSMSCode(
        countryCode: form.countryCode,
        mobileNumber: form.mobileNumber,
        uuid: form.uuid,
      ),
    );
  }
}
