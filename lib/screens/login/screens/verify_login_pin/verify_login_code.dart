import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:darkpanda_flutter/app.dart';
import 'package:darkpanda_flutter/screens/auth/services/util.dart';

import '../../bloc/send_login_verify_code_bloc.dart';

// @TODO
//   - Assert that all numbers submitted are numeric.
//   - Redirect to app index page when login success.
//   - Shake the pin code field and notify error if failed to verify.
//     Add an bloc listener to subscribe to verify result from the server.
//     Error shaking behavior would be triggered based on the result.
class VerifyLoginCode extends StatefulWidget {
  const VerifyLoginCode();

  @override
  _VerifyLoginCodeState createState() => _VerifyLoginCodeState();
}

class _VerifyLoginCodeState extends State<VerifyLoginCode> {
  String _inputVerifyCode;

  // StreamController<ErrorAnimationType> errorController;

  bool hasError = false;

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
              '我們已傳送驗證碼到此帳號的綁定手機 *******880',
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
    // final sState = BlocProvider.of<SendLoginVerifyCodeBloc>(context).state;

    // emit verify login code event
    // BlocProvider.of<VerifyLoginCodeBloc>(context).add(
    //   SendVerifyLoginCode(
    //     mobile: sState.mobile,
    //     uuid: sState.uuid,
    //     verifyChars: sState.verifyChar,
    //     verifyDigs: pin,
    //   ),
    // );

    // If login success redirect to app.
    // Navigator.of(
    //   context,
    //   rootNavigator: true,
    // ).push(
    //   MaterialPageRoute(
    //     builder: (context) => App(),
    //   ),
    // );
  }

  Widget _buildVerifyCodeForm(BuildContext context) {
    final BoxDecoration pinputDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      borderRadius: BorderRadius.circular(8),
    );

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

              // verify code input
              Container(
                margin: EdgeInsets.only(top: 26),
                child: PinPut(
                  onSubmit: (String pin) => handleSubmit(context, pin),
                  keyboardType: TextInputType.number,
                  fieldsCount: 4,
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
              ),
            ],
          ),
        ),
        // send button
      ],
    );
  }

  handleTriggerResend() {
    print('trigger resend');
    // Trigger resend token API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登入'),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 26),
              _buildDescBlock(),
              SizedBox(height: 11),
              _buildVerifyCodeForm(context),
              SizedBox(height: 36),
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
                    width: 17,
                  ),
                  InkWell(
                    child: Text(
                      '重寄驗證碼',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.47,
                        color: Colors.white,
                      ),
                    ),
                    onTap: handleTriggerResend,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
