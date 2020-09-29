import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../bloc/verify_login_code_bloc.dart';
import '../bloc/send_login_verify_code_bloc.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }

  return double.tryParse(s) != null;
}

// @TODO
//   - Assert that all numbers submitted are numeric.
//   - Redirect to app index page when login success.
//   - Shake the ping code field and notify error if failed to verify.
//     Add an bloc listener to subscribe to verify result from the server.
//     Error shaking behavior would be triggered based on the result.
class VerifyLoginCode extends StatefulWidget {
  const VerifyLoginCode();

  @override
  _VerifyLoginCodeState createState() => _VerifyLoginCodeState();
}

class _VerifyLoginCodeState extends State<VerifyLoginCode> {
  String _inputVerifyCode;

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  _emitSendVerifyLoginCode(BuildContext context, String verifyDigs) {
    // Retrieve mobile and verifyChar from `SendLoginVerifyCodeBloc`.
    final sState = BlocProvider.of<SendLoginVerifyCodeBloc>(context).state;

    // emit verify login code event
    BlocProvider.of<VerifyLoginCodeBloc>(context).add(SendVerifyLoginCode(
      mobile: sState.mobile,
      uuid: sState.uuid,
      verifyChars: sState.verifyChar,
      verifyDigs: verifyDigs,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verify login code'),
      ),
      body: Container(
        child: PinCodeTextField(
          errorAnimationController: errorController,
          appContext: context,
          length: 4,
          onChanged: (String value) {
            setState(() {
              _inputVerifyCode = value;
            });
          },
          onCompleted: (String value) {
            if (isNumeric(value)) {
              // emit verify login code event
              _emitSendVerifyLoginCode(context, value);

              setState(() {
                hasError = false;
              });
            } else {
              errorController.add(ErrorAnimationType.shake);

              setState(() {
                hasError = true;
              });
            }
          },
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
