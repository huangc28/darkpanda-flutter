import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/register/components/step_bar_image.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:darkpanda_flutter/screens/register/screen_arguments/args.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/register/bloc/send_sms_code_bloc.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';

// import '../../bloc/send_sms_code_bloc.dart';
//  import '../../bloc';

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
  const SendRegisterVerifyCode({
    this.onPush,
    this.args,
  });

  final Function(String, [VerifyRegisterCodeArguments]) onPush;
  final SendRegisterVerifyCodeArguments args;

  @override
  _SendRegisterVerifyCodeState createState() => _SendRegisterVerifyCodeState();
}

// @TODO apply best practice on mobile number input masking.
class _SendRegisterVerifyCodeState<Error extends AppBaseException>
    extends State<SendRegisterVerifyCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumController = TextEditingController();

  String _mobileNumber;
  String _dialCode = '+886';
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
            horizontal: SizeConfig.screenHeight * 0.02, //16.0,
            vertical: 0,
          ),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            bloc: BlocProvider.of<RegisterBloc>(context),
            builder: (context, registerState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StepBarImage(
                  step: RegisterStep.StepThree,
                ),
                SizedBox(
                  // height: 46,
                  height: SizeConfig.screenHeight * 0.08,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenHeight * 0.02, //14,
                        vertical: 0,
                      ),
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
                            SizedBox(
                              // height: 11,
                              height: SizeConfig.screenHeight * 0.02,
                            ),
                            Text(
                              '驗證碼會寄至您的手機',
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.47,
                                color: Color.fromRGBO(106, 109, 137, 1),
                              ),
                            ),
                            SizedBox(
                              // height: 26,
                              height: SizeConfig.screenHeight * 0.05,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CountryCodePicker(
                                  onChanged: (CountryCode code) {
                                    setState(() {
                                      _dialCode = code.dialCode;
                                    });
                                  },
                                  initialSelection: 'TW',
                                  favorite: ['+886', 'TW'],
                                  countryFilter: ['TW'],
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  showCountryOnly: true,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 2),

                                // Mobile number text input
                                Expanded(
                                  child: DPTextFormField(
                                    keyboardType: TextInputType.phone,
                                    hintText: '輸入電話號碼',
                                    controller: _mobileNumController,
                                    validator: (String v) {
                                      // Makesure the phone number input is are all number
                                      if (!Util.isNumeric(v)) {
                                        return '電話號碼必須是數字';
                                      }

                                      return null;
                                    },
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
                                    onSaved: (String v) {
                                      _mobileNumber = v;
                                    },
                                    contentPadding: EdgeInsets.only(
                                      left:
                                          SizeConfig.screenWidth * 0.05, //14.0,
                                      bottom: SizeConfig.screenHeight * 0.01,
                                      top: SizeConfig.screenHeight * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              // height: 46,
                              height: SizeConfig.screenHeight * 0.07,
                            ),
                            BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                              listener: (context, state) {
                                if (state.status == AsyncLoadingStatus.done) {
                                  // Redirect to phone verify page
                                  widget.onPush(
                                    '/register/verify-register-code',
                                    VerifyRegisterCodeArguments(
                                      dialCode: _dialCode,
                                      mobile: _mobileNumber,
                                      verifyChars: state.sendSMS.verifyPrefix,
                                      uuid: widget.args.userUuid,
                                    ),
                                  );
                                }

                                if (state.status == AsyncLoadingStatus.error) {
                                  print('sending sms error');

                                  // Display error
                                }
                              },
                              child: SizedBox(
                                height: SizeConfig.screenHeight * 0.065,
                                child: DPTextButton(
                                  disabled: _disableSend,
                                  text: '寄驗證碼',
                                  onPressed: () {
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }

                                    _formKey.currentState.save();

                                    BlocProvider.of<SendSmsCodeBloc>(context)
                                        .add(
                                      SendSMSCode(
                                        dialCode: _dialCode,
                                        mobileNumber: _mobileNumber,
                                        uuid: widget.args.userUuid,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
