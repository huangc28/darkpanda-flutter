import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import './bloc/verify_referral_code_bloc.dart';

import '../../components/step_bar_image.dart';

class VerifyReferralCode extends StatefulWidget {
  const VerifyReferralCode({
    Key key,
    this.onPush,
  }) : super(key: key);

  final ValueChanged<String> onPush;

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
    final BoxDecoration pinputDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      borderRadius: BorderRadius.circular(8),
    );

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
                        PinPut(
                          inputDecoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.47,
                            ),
                            focusedErrorBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
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
                          keyboardType: TextInputType.number,
                          fieldsCount: 6,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          submittedFieldDecoration: pinputDecoration,
                          selectedFieldDecoration: pinputDecoration,
                          followingFieldDecoration: pinputDecoration,
                          eachFieldWidth: 50,
                          eachFieldHeight: 57,
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
                  )),

              MultiBlocListener(
                listeners: [
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

                      // Let's redirect to phone verify page
                      widget.onPush('/register/send-verify-code');
                    }
                  }),
                ],
                child: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: DPTextButton(
                      theme: DPTextButtonThemes.purple,
                      onPressed: () {
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

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
