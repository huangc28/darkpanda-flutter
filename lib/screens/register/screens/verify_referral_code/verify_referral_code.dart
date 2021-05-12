import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_pin_put.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/register/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';

import './bloc/verify_referral_code_bloc.dart';

import '../../components/step_bar_image.dart';

class VerifyReferralCode extends StatefulWidget {
  const VerifyReferralCode({
    Key key,
    this.onPush,
    this.args,
  }) : super(key: key);

  final Function(String, SendRegisterVerifyCodeArguments) onPush;
  final VerifyReferralCodeArguments args;

  @override
  _VerifyReferralCodeState createState() => _VerifyReferralCodeState();
}

class _VerifyReferralCodeState extends State<VerifyReferralCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _usernameControler = TextEditingController();

  String _referralCode;
  String _username;

  String _verifyRefCodeErrStr = '';
  String _verifyUsernameErrStr = '';

  handleSubmit(BuildContext build, String pin) {
    print('trigger verify referral code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepBarImage(
                step: RegisterStep.StepTwo,
              ),

              SizedBox(height: 46),
              // Pin code input field
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '輸入你的推薦碼',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 26),
                      DPPinPut(
                        onSubmit: (String pin) => handleSubmit(context, pin),
                        onSaved: (String v) {
                          _referralCode = v;
                        },
                        validator: (String v) {
                          if (v.trim().isEmpty) {
                            return 'verify code can not be empty';
                          }

                          if (v.trim().length < 6) {
                            return 'please complete verify code';
                          }

                          if (_verifyRefCodeErrStr != null &&
                              !_verifyRefCodeErrStr.isEmpty) {
                            return _verifyRefCodeErrStr;
                          }

                          return null;
                        },
                        controller: _pinCodeController,
                        fieldsCount: 6,
                      ),
                      SizedBox(height: 46),
                      Text(
                        '建立你的用戶名',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 26),

                      // Username input
                      DPTextFormField(
                        controller: _usernameControler,
                        onSaved: (String v) {
                          _username = v;
                        },
                        validator: (String v) {
                          if (v.trim().isEmpty) {
                            return 'username can not be empty';
                          }

                          // If username does not pass async validation,
                          // display error message
                          if (_verifyUsernameErrStr != null &&
                              !_verifyUsernameErrStr.isEmpty) {
                            return _verifyUsernameErrStr;
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              MultiBlocListener(
                listeners: [
                  BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      // If register successfully, we redirect to send register verify code
                      if (state.status == AsyncLoadingStatus.done) {
                        // state.user.uuid
                        widget.onPush(
                          '/register/send-verify-code',
                          SendRegisterVerifyCodeArguments(
                            username: _username,
                            userUuid: state.user.uuid,
                          ),
                        );
                      }

                      if (state.status == AsyncLoadingStatus.error) {
                        print('registering error!');
                      }
                    },
                  ),
                  BlocListener<VerifyReferralCodeBloc, VerifyReferralCodeState>(
                      listener: (context, state) {
                    if (state.status == AsyncLoadingStatus.error) {
                      setState(() {
                        _verifyRefCodeErrStr =
                            state.verifyRefCodeError?.message;

                        _verifyUsernameErrStr =
                            state.verifyUsernameError?.message;
                      });

                      _formKey.currentState.validate();
                    }

                    if (state.status == AsyncLoadingStatus.done) {
                      setState(() {
                        _verifyRefCodeErrStr = '';
                        _verifyUsernameErrStr = '';
                      });

                      _formKey.currentState.save();

                      // If verify code and and username are all valid,
                      // register a new user.
                      BlocProvider.of<RegisterBloc>(context).add(
                        Register(
                          username: _username,
                          gender: widget.args.gender,
                          referalcode: _referralCode,
                        ),
                      );
                    }
                  }),
                ],
                child: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 44,
                      child: DPTextButton(
                        theme: DPTextButtonThemes.purple,
                        onPressed: () {
                          /// Reset async error before performing validation
                          setState(() {
                            _verifyRefCodeErrStr = '';
                            _verifyUsernameErrStr = '';
                          });

                          /// verify pin code input and username synchronously
                          if (!_formKey.currentState.validate()) {
                            return null;
                          }

                          _formKey.currentState.save();

                          /// verify pin code and username validity asynchornously
                          BlocProvider.of<VerifyReferralCodeBloc>(context).add(
                            VerifyReferralCodeEvent(
                              referralCode: _referralCode,
                              username: _username,
                            ),
                          );

                          /// The rest of the form operations `_formKey.save()`, `_formKey.validate()`
                          /// will be performed in bloc listeners
                        },
                        text: '下一步',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
