part of './phone_verify_form.dart';

class SendSMSButton<Error extends AppBaseException> extends StatelessWidget {
  final Error sendSMSError;
  final Function onPressed;

  const SendSMSButton({
    @required this.onPressed,
    this.sendSMSError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: sendSMSError != null ? Text(sendSMSError.message) : Text(''),
        ),
        RaisedButton(
          child: Text(
            'Send',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
