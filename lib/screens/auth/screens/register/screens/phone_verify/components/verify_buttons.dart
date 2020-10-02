part of './send_phone_verify_code.dart';

/// Renders partial forms of phone_verify_form. This partial widget includes
class VerifyButtons<Error extends AppBaseException> extends StatefulWidget {
  final Error verifyCodeError;
  final Error fetchAuthUserError;
  final bool enableResend;
  final Function onResendSMS;
  final Function onVerify;

  const VerifyButtons({
    @required this.onResendSMS,
    @required this.onVerify,
    this.verifyCodeError,
    this.fetchAuthUserError,
    this.enableResend = true,
  });

  @override
  _VerifyButtonsState createState() => _VerifyButtonsState();
}

class _VerifyButtonsState<Error extends AppBaseException>
    extends State<VerifyButtons<Error>> {
  bool _enableResend = true;

  @override
  Widget build(BuildContext context) {
    final displayError = widget.verifyCodeError ?? widget.fetchAuthUserError;

    return Column(
      children: [
        Container(
          child: displayError == null ? Text('') : Text(displayError.message),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MultiBlocListener(
              listeners: [
                BlocListener<SendSmsCodeBloc, SendSmsCodeState>(
                  listener: (context, state) {
                    if (state.status == SendSMSStatus.sending) {
                      setState(() {
                        _enableResend = false;
                      });
                    }
                  },
                ),
                BlocListener<TimerBloc, TimerState>(
                  listener: (context, state) {
                    if (state.status == TimerStatus.ready ||
                        state.status == TimerStatus.completed) {
                      setState(() {
                        _enableResend = true;
                      });
                    }
                  },
                ),
              ],
              child: Container(
                width: 0,
                height: 0,
              ),
            ),
            BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
              final resendButtonText = state.status == TimerStatus.progressing
                  ? '${state.duration}'
                  : 'Resend';

              final resendHandler = _enableResend ? widget.onResendSMS : null;

              return RaisedButton(
                child: Text(
                  resendButtonText,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: resendHandler,
              );
            }),
            SizedBox(width: 20.0),
            RaisedButton(
              child: Text(
                'Verify',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              onPressed: widget.onVerify,
            )
          ],
        ),
      ],
    );
  }
}
