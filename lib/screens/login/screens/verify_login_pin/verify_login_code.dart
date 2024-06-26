import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';
import 'package:darkpanda_flutter/util/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/female/female_app.dart';
import 'package:darkpanda_flutter/screens/male/male_app.dart';

import 'package:darkpanda_flutter/main.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:darkpanda_flutter/components/dp_pin_put.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';

import './util/mobile_masker.dart';
import '../../bloc/verify_login_code_bloc.dart';
import '../../bloc/send_login_verify_code_bloc.dart';
import '../../screen_arguments/args.dart';

// @TODO
//   - Shake the pin code field and notify error if failed to verify.
//     Add an bloc listener to subscribe to verify result from the server.
//     Error shaking behavior would be triggered based on the result.
class VerifyLoginCode extends StatefulWidget {
  const VerifyLoginCode({
    this.args,
  });

  final VerifyLoginPinArguments args;

  @override
  _VerifyLoginCodeState createState() => _VerifyLoginCodeState();
}

class _VerifyLoginCodeState extends State<VerifyLoginCode> {
  final TextEditingController _pinCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    NotificationService().init();
    FirebaseMessagingService().init();
  }

  Widget _buildDescBlock() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(255, 255, 255, 0.1),
            ),
            padding: EdgeInsets.fromLTRB(16, 14, 6, 14),
            height: 72,
            child: Text(
              '我們已傳送驗證碼到此帳號的綁定手機 ${MobileMasker.mask(widget.args.mobile)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                letterSpacing: 0.3,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  handleSubmit(BuildContext context, String pin) {
    final verifyPrefix =
        BlocProvider.of<SendLoginVerifyCodeBloc>(context).state.verifyChar;

    BlocProvider.of<VerifyLoginCodeBloc>(context).add(
      SendVerifyLoginCode(
        mobile: widget.args.mobile,
        uuid: widget.args.uuid,
        verifyChars: verifyPrefix,
        verifyDigs: pin,
      ),
    );
  }

  Widget _buildVerifyCodeForm(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Label
              Text(
                '輸入你收到的驗證碼',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                  height: 2,
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 26),
                child: BlocListener<VerifyLoginCodeBloc, VerifyLoginCodeState>(
                  listener: (context, state) {
                    // If verify success, redirect to application.
                    if (state.status == AsyncLoadingStatus.done) {
                      DarkPandaApp.valueNotifier.value = false;

                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => state.gender == Gender.female
                              ? FemaleApp()
                              : MaleApp(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Form(
                    key: _formKey,
                    child: DPPinPut(
                      controller: _pinCodeController,
                      onSubmit: (String pin) => handleSubmit(context, pin),
                      fieldsCount: 4,
                      validator: (String v) {
                        if (v.isEmpty) {
                          return 'pin code can not be empty';
                        }

                        if (!Util.isNumeric(v)) {
                          return 'pin code must be numeric number';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ),

              // Display error message of verifying login code.
              SizedBox(
                height: 28,
                child: BlocBuilder<VerifyLoginCodeBloc, VerifyLoginCodeState>(
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
      ],
    );
  }

  handleTriggerResend() {
    // Trigger resend token API
    BlocProvider.of<SendLoginVerifyCodeBloc>(context).add(
      SendLoginVerifyCode(
        username: widget.args.username,
      ),
    );
  }

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
          onTap: state.status == TimerStatus.progressing
              ? null
              : handleTriggerResend,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('登入'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: SizeConfig.screenHeight * 0.05,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildDescBlock(),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      _buildVerifyCodeForm(context),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Row(
                        children: [
                          Text(
                            '沒有收到驗證碼?',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.47,
                              color: Color.fromRGBO(106, 109, 137, 1),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.05,
                          ),
                          BlocBuilder<SendLoginVerifyCodeBloc,
                              SendLoginVerifyCodeState>(
                            builder: (BuildContext, state) {
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
                            },
                          ),
                        ],
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      // Resend login verify code error message.
                      Expanded(
                        child: BlocBuilder<SendLoginVerifyCodeBloc,
                            SendLoginVerifyCodeState>(
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
          ],
        ),
      ),
    );
  }
}
