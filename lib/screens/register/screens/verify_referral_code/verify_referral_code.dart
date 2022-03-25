import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/dp_pin_put.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/register/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';

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
  final TextEditingController _usernameControler = TextEditingController();

  String _username;

  String _verifyUsernameErrStr = '';

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      title: Text('註冊'),
    );
    var _appBarSize = appBar.preferredSize.height;
    var _notifySize = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: UnfocusPrimary(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenHeight * 0.02,
              vertical: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepBarImage(
                  step: RegisterStep.StepTwo,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.08,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: SizeConfig.screenHeight -
                          (_notifySize +
                              _appBarSize +
                              (SizeConfig.screenHeight * 0.11)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: SizeConfig.screenHeight * 0.75),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Pin code input field
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.screenHeight * 0.02,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '建立你的用戶名',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),

                                      SizedBox(
                                        height: 18,
                                      ),

                                      // Username input
                                      DPTextFormField(
                                        theme: DPTextFieldThemes.transparent,
                                        controller: _usernameControler,
                                        onSaved: (String v) {
                                          _username = v;
                                        },
                                        validator: (String v) {
                                          if (v.trim().isEmpty) {
                                            return '請輸入用戶名';
                                          }

                                          // Username has to be at least 6 chars.
                                          if (v.length < 6) {
                                            return '用戶名必須至少為 6 個字符';
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
                                      if (state.status ==
                                          AsyncLoadingStatus.done) {
                                        // state.user.uuid
                                        widget.onPush(
                                          '/register/send-verify-code',
                                          SendRegisterVerifyCodeArguments(
                                            username: _username,
                                            userUuid: state.user.uuid,
                                          ),
                                        );
                                      }

                                      if (state.status ==
                                          AsyncLoadingStatus.error) {
                                        print('registering error!');
                                      }
                                    },
                                  ),
                                  BlocListener<VerifyReferralCodeBloc,
                                          VerifyReferralCodeState>(
                                      listener: (context, state) {
                                    if (state.status ==
                                        AsyncLoadingStatus.error) {
                                      setState(() {
                                        _verifyUsernameErrStr =
                                            state.verifyUsernameError?.message;
                                      });

                                      _formKey.currentState.validate();
                                    }

                                    if (state.status ==
                                        AsyncLoadingStatus.done) {
                                      setState(() {
                                        _verifyUsernameErrStr = '';
                                      });

                                      _formKey.currentState.save();

                                      // If verify code and and username are all valid,
                                      // register a new user.
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(
                                        Register(
                                          username: _username,
                                          gender: widget.args.gender,
                                          // referalcode: _referralCode,
                                        ),
                                      );
                                    }
                                  }),
                                ],
                                child: Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: SizeConfig.screenHeight * 0.065,
                                      child: BlocBuilder<VerifyReferralCodeBloc,
                                          VerifyReferralCodeState>(
                                        builder: (context, state) {
                                          return DPTextButton(
                                            loading: state.status ==
                                                AsyncLoadingStatus.loading,
                                            theme: DPTextButtonThemes.purple,
                                            onPressed: () {
                                              // Reset async error before performing validation
                                              setState(() {
                                                _verifyUsernameErrStr = '';
                                              });

                                              // verify pin code input and username synchronously
                                              if (!_formKey.currentState
                                                  .validate()) {
                                                return null;
                                              }

                                              _formKey.currentState.save();

                                              // verify pin code and username validity asynchornously
                                              BlocProvider.of<
                                                          VerifyReferralCodeBloc>(
                                                      context)
                                                  .add(
                                                VerifyReferralCodeEvent(
                                                  // referralCode: _referralCode,
                                                  username: _username,
                                                ),
                                              );

                                              // The rest of the form operations `_formKey.save()`, `_formKey.validate()`
                                              // will be performed in bloc listeners
                                            },
                                            text: '下一步',
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.04,
                              ),
                            ],
                          ),
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
