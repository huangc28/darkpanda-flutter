import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/screens/register/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/register/components/step_bar_image.dart';
import 'package:darkpanda_flutter/components/dp_pin_put.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/app.dart';

import 'package:darkpanda_flutter/screens/register/bloc/send_sms_code_bloc.dart';

import './bloc/mobile_verify_bloc.dart';

class VerifyRegisterCode extends StatefulWidget {
  const VerifyRegisterCode({this.args});

  final VerifyRegisterCodeArguments args;

  @override
  _VerifyRegisterCodeState createState() => _VerifyRegisterCodeState();
}

class _VerifyRegisterCodeState extends State<VerifyRegisterCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();

  String _mobileVerifyErrStr = '';
  String _mobileVerifyChars = '';

  @override
  void initState() {
    setState(() {
      _mobileVerifyChars = widget.args.verifyChars;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('註冊')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StepBarImage(
                step: RegisterStep.StepFour,
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
                        '輸入你收到的驗證碼',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 26),

                      BlocListener<MobileVerifyBloc, MobileVerifyState>(
                        listener: (context, state) {
                          if (state.status == AsyncLoadingStatus.error) {
                            setState(() {
                              _mobileVerifyErrStr = state.error.message;
                            });

                            _formKey.currentState.validate();
                          }

                          if (state.status == AsyncLoadingStatus.done) {
                            /// Remove mobile verify async error string
                            _mobileVerifyErrStr = '';

                            /// Redirect to app page.
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(MaterialPageRoute(
                              builder: (context) => App(),
                            ));
                          }
                        },
                        child: DPPinPut(
                          controller: _pinCodeController,
                          fieldsCount: 4,
                          onSubmit: (String v) {
                            setState(() {
                              _mobileVerifyErrStr = '';
                            });

                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            // Perform async validation on phone verify code.
                            BlocProvider.of<MobileVerifyBloc>(context)
                                .add(VerifyMobile(
                              verifyChars: _mobileVerifyChars,
                              verifyDigs: v,
                              uuid: widget.args.uuid,
                              mobileNumber:
                                  '${widget.args.dialCode}${widget.args.mobile}',
                            ));
                          },
                          validator: (String v) {
                            if (v.trim().isEmpty) {
                              return 'verify code can not be empty';
                            }

                            if (!Util.isNumeric(v)) {
                              return 'verify code must be numeric';
                            }

                            if (!_mobileVerifyErrStr.isEmpty) {
                              return _mobileVerifyErrStr;
                            }

                            return null;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 46,
                      ),

                      /// Resend validation code
                      BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                        listener: (context, state) {
                          if (state.status == AsyncLoadingStatus.done) {
                            setState(() {
                              _mobileVerifyChars = state.sendSMS.verifyPrefix;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              '沒有收到驗證碼？',
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.47,
                                color: Color.fromRGBO(106, 109, 137, 1),
                              ),
                            ),
                            BlocBuilder<SendSmsCodeBloc, SendSmsCodeState>(
                                builder: (BuildContext builder, state) {
                              if (state.status == AsyncLoadingStatus.loading) {
                                return Text(
                                  '重寄中',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                );
                              }
                              return _buildResendButton();
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Render resend button widget. Disable button if timer is ticking.
  Widget _buildResendButton() => BlocBuilder<TimerBloc, TimerState>(
          builder: (BuildContext context, state) {
        final ResendButtonText = state.status == TimerStatus.progressing
            ? Text(
                '重寄請稍等 (${state.duration})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              )
            : Text(
                '重寄驗證碼',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              );

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              child: ResendButtonText,
              onTap: state.status == TimerStatus.progressing
                  ? null
                  : _handleResend,
            ),
          ],
        );
      });

  void _handleResend() {
    BlocProvider.of<SendSmsCodeBloc>(context).add(
      SendSMSCode(
        dialCode: widget.args.dialCode,
        mobileNumber: widget.args.mobile,
        uuid: widget.args.uuid,
      ),
    );
  }
}