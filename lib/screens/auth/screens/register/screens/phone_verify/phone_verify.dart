import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';

import 'components/send_phone_verify_code.dart';
import './bloc/send_sms_code_bloc.dart';
import './bloc/mobile_verify_bloc.dart';
import './models/phone_verify_form.dart' as models;
import '../../bloc/register_bloc.dart';
import '../../constants.dart';

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
class RegisterPhoneVerify extends StatefulWidget {
  const RegisterPhoneVerify({this.onPush});

  final ValueChanged<String> onPush;

  @override
  _RegisterPhoneVerifyState createState() => _RegisterPhoneVerifyState();
}

class _RegisterPhoneVerifyState<Error extends AppBaseException>
    extends State<RegisterPhoneVerify> {
  /// verify code prefix as of form {preffix-suffix}
  String _verifyCodePrefix;

  /// Error object to pass to `phone_verify_form` for displaying error message
  /// when failed to verify mobile.
  // Error _verifyCodeError;

  /// Error object to pass to `phone_verify_form` for displaying error message
  /// when failed to send SMS code.
  Error _sendSMSCodeError;

  /// Error object to pass to `phone_verify_form` for displaying error message
  /// when failed to fetch auth user error.
  Error _fetchAuthUserError;

  /// A flag to indicate which of the `resend` or `send` to show.
  bool _hasSend = false;

  String _phoneVerifyCode;

  void _handleVerify(BuildContext context, models.PhoneVerifyFormModel form) {
    BlocProvider.of<MobileVerifyBloc>(context).add(
      VerifyMobile(
        mobileNumber: '${form.countryCode}${form.mobileNumber}',
        uuid: form.uuid,
        prefix: form.prefix,
        suffix: form.suffix,
      ),
    );
  }

  void _handleResendSMS(
      BuildContext context, models.PhoneVerifyFormModel form) {
    // trigger send SMS again
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
          child: BlocBuilder<RegisterBloc, RegisterState>(
              cubit: BlocProvider.of<RegisterBloc>(context),
              builder: (context, registerState) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      MultiBlocListener(
                        listeners: [
                          BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                            listener: (context, state) {
                              // listen to SendSMS state. if sms has been send successfully for the first time,
                              // show the buttons to send verify code.
                              if (state.status == SendSMSStatus.sending) {
                                // setState(() {
                                //   _sendSMSCodeError = null;
                                // });
                              }

                              if (state.status == SendSMSStatus.sendSuccess) {
                                // setState(() {
                                //   _hasSend = true;
                                //   _verifyCodePrefix =
                                //       state.sendSMS.verifyPrefix;
                                // });
                                // redirect to next page to verify phone.
                                widget.onPush('/register/verify-register-code');
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
                          BlocListener<MobileVerifyBloc, MobileVerifyState>(
                            listener: (context, state) {
                              if (state.status ==
                                  MobileVerifyStatus.verifyFailed) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error.message),
                                  ),
                                );

                                return null;
                              }

                              if (state.status ==
                                  MobileVerifyStatus.verified) {}
                            },
                          ),
                          BlocListener<AuthUserBloc, AuthUserState>(
                              listener: (context, state) {
                            // display error if failed to retrieve auth user info
                            if (state.status == FetchUserStatus.fetchFailed) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.error.message),
                                ),
                              );

                              return null;
                            }

                            if (state.status == FetchUserStatus.fetchSuccess) {
                              // redirect to index page according to gender.
                              // `/female/inquiry` is the index page for the female users
                              // `/male/search_inquiry` is the index page for male users
                              final next =
                                  state.user.gender == Gender.female.toString()
                                      ? '/female/inquiry'
                                      : '/male/search_inquiry';

                              Navigator.pushNamed(context, next);
                            }
                          }),
                        ],
                        child: SendPhoneVerifyCode(
                          onSend: (models.PhoneVerifyFormModel form) {
                            form.uuid = registerState.user.uuid;
                            _handleSendSMS(form);
                          },
                          // hasSend: _hasSend,
                          // verifyCodePrefix: _verifyCodePrefix,
                          // // verifyCodeError: _verifyCodeError,
                          // fetchAuthUserError: _fetchAuthUserError,
                          // sendSMSError: _sendSMSCodeError,
                          // onSendSMS: (models.PhoneVerifyFormModel form) {
                          //   form.uuid = registerState.user.uuid;
                          //   _handleSendSMS(context, form);
                          // },
                          // onResendSMS: (models.PhoneVerifyFormModel form) {
                          //   form.uuid = registerState.user.uuid;
                          //   _handleResendSMS(context, form);
                          // },
                          // onVerify: (models.PhoneVerifyFormModel form) {
                          //   form.uuid = registerState.user.uuid;
                          //   _handleVerify(context, form);
                          // },
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
    BlocProvider.of<SendSmsCodeBloc>(context).add(
      SendSMSCode(
        countryCode: form.countryCode,
        mobileNumber: form.mobileNumber,
        uuid: form.uuid,
      ),
    );
  }

  // _handleChangePinCode(String value) {
  //   setState(() {
  //     _phoneVerifyCode = value;
  //   });
  // }
}
