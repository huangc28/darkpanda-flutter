part of './phone_verify_form.dart';

/// Renders partial forms of phone_verify_form. This partial widget includes
class VerifyButtons<Error extends AppBaseException> extends StatelessWidget {
  final Error verifyCodeError;
  final bool enableResend;
  final Function onResendSMS;
  final Function onVerify;

  const VerifyButtons({
    @required this.onResendSMS,
    @required this.onVerify,
    this.verifyCodeError,
    this.enableResend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: verifyCodeError != null
              ? Text(verifyCodeError.message)
              : Text(''),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<TimerBloc, TimerState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final resendButtonText =
                      state.status == TimerStatus.progressing
                          ? '${state.duration}'
                          : 'Resend';

                  final resendHandler = state.status == TimerStatus.progressing
                      ? null
                      : onResendSMS;

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
              onPressed: onVerify,
            )
          ],
        ),
      ],
    );
  }
}
