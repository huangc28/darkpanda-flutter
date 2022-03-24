import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/components/dp_pin_put.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/screens/female/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/female/female_app.dart';
import 'package:darkpanda_flutter/screens/male/bottom_navigation.dart';
import 'package:darkpanda_flutter/screens/male/male_app.dart';
import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/bloc/send_change_mobile_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/bloc/verify_change_mobile_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/components/mobile_changed_dialog.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/screen_arguments/verify_change_mobile_arguments.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.args,
  }) : super(key: key);

  final VerifyChangeMobileArguments args;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formNewPinKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();

  String _mobileVerifyErrStr = '';
  String _verifyPrefix = '';

  @override
  void initState() {
    _verifyPrefix = widget.args.verifyChars;

    super.initState();
  }

  handleTriggerResend() {
    // Trigger resend token API
    BlocProvider.of<SendChangeMobileBloc>(context).add(
      SendChangeMobile(widget.args.dialCode + widget.args.mobile),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.04,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: SizeConfig.screenHeight * 0.05,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenHeight * 0.02,
                      vertical: 0,
                    ),
                    child: Form(
                      key: _formNewPinKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '輸入你收到的驗證碼',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.05,
                          ),
                          BlocListener<VerifyChangeMobileBloc,
                              VerifyChangeMobileState>(
                            listener: (context, state) {
                              if (state.status == AsyncLoadingStatus.error) {
                                setState(() {
                                  _mobileVerifyErrStr = state.error.message;
                                });

                                _formNewPinKey.currentState.validate();
                              }

                              if (state.status == AsyncLoadingStatus.done) {
                                _mobileVerifyErrStr = '';
                                final gender =
                                    BlocProvider.of<AuthUserBloc>(context)
                                        .state
                                        .user
                                        .gender;

                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MobileChangedDialog();
                                  },
                                ).then((value) {
                                  if (gender == Gender.female) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (c) => FemaleApp(
                                            selectedTab: TabItem.settings,
                                          ),
                                        ),
                                        (route) => false);
                                  } else if (gender == Gender.male) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (c) => MaleApp(
                                            selectedTab:
                                                MaleAppTabItem.settings,
                                          ),
                                        ),
                                        (route) => false);
                                  }
                                });
                              }
                            },
                            child: DPPinPut(
                              controller: _pinCodeController,
                              fieldsCount: 4,
                              onSubmit: (String v) {
                                setState(() {
                                  _mobileVerifyErrStr = '';
                                });

                                if (!_formNewPinKey.currentState.validate()) {
                                  return;
                                }

                                // Perform async validation on phone verify code.
                                BlocProvider.of<VerifyChangeMobileBloc>(context)
                                    .add(
                                  VerifyChangeMobile(_verifyPrefix + '-' + v),
                                );
                              },
                              validator: (String v) {
                                if (v.trim().isEmpty) {
                                  return '請輸入驗證碼';
                                }

                                if (!Util.isNumeric(v)) {
                                  return '驗證碼必須是數字';
                                }

                                if (!_mobileVerifyErrStr.isEmpty) {
                                  return _mobileVerifyErrStr;
                                }

                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.08,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '沒有收到驗證碼？',
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.47,
                                  color: Color.fromRGBO(106, 109, 137, 1),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.05,
                              ),
                              BlocListener<SendChangeMobileBloc,
                                  SendChangeMobileState>(
                                listener: (context, state) {
                                  // If login verify code send successfully, update the current verify prefix
                                  // to the newest one.
                                  if (state.status == AsyncLoadingStatus.done) {
                                    setState(() {
                                      _verifyPrefix = state
                                          .sendChangeMobileResponse
                                          .verifyPrefix;
                                    });
                                  }
                                },
                                child: Container(),
                              ),
                              BlocBuilder<SendChangeMobileBloc,
                                  SendChangeMobileState>(
                                builder: (BuildContext, state) {
                                  if (state.status ==
                                      AsyncLoadingStatus.loading) {
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
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                          // Resend login verify code error message.
                          Expanded(
                            child: BlocBuilder<SendChangeMobileBloc,
                                SendChangeMobileState>(
                              builder: (context, state) {
                                if (state.status == AsyncLoadingStatus.error) {
                                  return Text(
                                    state.error.message,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  );
                                }

                                return Container();
                              },
                            ),
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
    );
  }

  /// Render resend button widget. Disable button if timer is ticking.
  Widget _buildResendButton() {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (BuildContext context, state) {
        return InkWell(
          child: Text(
            state.status == TimerStatus.progressing
                ? '重寄請稍等 (${state.duration})'
                : '重寄驗證碼',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: state.status == TimerStatus.progressing
              ? null
              : handleTriggerResend,
        );
      },
    );
  }
}
