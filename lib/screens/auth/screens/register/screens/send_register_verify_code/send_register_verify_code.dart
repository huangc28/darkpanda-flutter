import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/auth/components/step_bar_image.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import 'components/send_phone_verify_code.dart';
import 'models/phone_verify_form.dart' as models;

import '../../bloc/send_sms_code_bloc.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _mobileNumber;
  String _countryCode;
  bool _disableSend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0,
          ),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            cubit: BlocProvider.of<RegisterBloc>(context),
            builder: (context, registerState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StepBarImage(
                  step: RegisterStep.StepThree,
                ),
                SizedBox(
                  height: 48,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '輸入你的電話號碼',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 11),
                        Text(
                          '驗證碼會寄至您的手機',
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0.47,
                            color: Color.fromRGBO(106, 109, 137, 1),
                          ),
                        ),

                        SizedBox(height: 26),

                        // Mobile number text input
                        DPTextFormField(
                          hintText: '輸入電話號碼',
                          onChanged: (String v) {
                            // Enable send button when input field is not an empty string
                            if (v != null && v.isNotEmpty) {
                              setState(() {
                                _disableSend = false;
                              });
                            } else {
                              setState(() {
                                _disableSend = true;
                              });
                            }
                          },
                        ),

                        SizedBox(
                          height: 46,
                        ),

                        DPTextButton(
                          disabled: _disableSend,
                          text: '寄驗證碼',
                          onPressed: () {
                            print('DEBUG trigger send');
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
