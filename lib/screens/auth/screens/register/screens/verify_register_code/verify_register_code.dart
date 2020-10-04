import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:darkpanda_flutter/screens/auth/services/util.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';

import '../phone_verify/bloc/send_sms_code_bloc.dart';
import './bloc/mobile_verify_bloc.dart';

class VerifyRegisterCode extends StatefulWidget {
  const VerifyRegisterCode({
    this.countryCode,
    this.mobile,
    this.verifyChars,
    this.uuid,
  });

  final String countryCode;
  final String mobile;
  final String verifyChars;
  final String uuid;

  @override
  _VerifyRegisterCodeState createState() => _VerifyRegisterCodeState();
}

class _VerifyRegisterCodeState extends State<VerifyRegisterCode> {
  final TextEditingController _textEditingController = TextEditingController();

  String _verifyDigs;

  StreamController<ErrorAnimationType> _errorController;
  @override
  void initState() {
    super.initState();

    initErrorAnimationController();
  }

  @override
  void didUpdateWidget(VerifyRegisterCode oldWidget) {
    super.didUpdateWidget(oldWidget);

    initErrorAnimationController();
  }

  @override
  void dispose() {
    _errorController.close();

    super.dispose();
  }

  /// Guards multiple instantiation of stream from flutter hot reload.
  void initErrorAnimationController() {
    if (_errorController == null || _errorController.isClosed) {
      _errorController = StreamController<ErrorAnimationType>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('verify register code')),
      body: BlocListener<MobileVerifyBloc, MobileVerifyState>(
        listener: (BuildContext context, state) {
          // if verify success, redirect to app index page.
          if (state.status == MobileVerifyStatus.verified) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(
              '/app',
            );
          }

          if (state.status == MobileVerifyStatus.verifyFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          }
        },
        child: Column(
          children: [
            Text('Sending to: ${widget.countryCode}${widget.mobile}'),
            SizedBox(height: 16),
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
                child: Column(
                  children: [
                    PinCodeTextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.number,
                      errorAnimationController: _errorController,
                      appContext: context,
                      length: 4,
                      onChanged: (String value) {
                        _verifyDigs = value;
                      },
                      onCompleted: _handleVerify,
                    ),
                    _buildResendButton(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  /// Render resend button widget. Disable button if timer is ticking.
  Widget _buildResendButton() => BlocBuilder<TimerBloc, TimerState>(
          builder: (BuildContext context, state) {
        final ResendButtonText = state.status == TimerStatus.progressing
            ? Text('Resend(${state.duration})')
            : Text('Resend');

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: ResendButtonText,
              onPressed: state.status == TimerStatus.progressing
                  ? null
                  : _handleResend,
            ),
          ],
        );
      });

  void _handleResend() {
    BlocProvider.of<SendSmsCodeBloc>(context).add(
      SendSMSCode(
        countryCode: widget.countryCode,
        mobileNumber: widget.mobile,
        uuid: widget.uuid,
      ),
    );
  }

  void _handleVerify(String value) {
    if (Util.isNumeric(_verifyDigs)) {
      BlocProvider.of<MobileVerifyBloc>(context).add(
        VerifyMobile(
          mobileNumber: '${widget.countryCode}${widget.mobile}',
          verifyChars: widget.verifyChars,
          verifyDigs: _verifyDigs,
          uuid: widget.uuid,
        ),
      );

      _textEditingController.clear();
    } else {
      _errorController.add(ErrorAnimationType.shake);
      _textEditingController.clear();
    }
  }
}
