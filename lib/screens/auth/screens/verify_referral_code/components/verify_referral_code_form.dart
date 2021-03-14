import 'package:flutter/material.dart';

import 'package:pinput/pin_put/pin_put.dart';

class VerifyReferralCodeForm extends StatefulWidget {
  const VerifyReferralCodeForm({
    Key key,
    @required this.handleSubmitPin,
  }) : super(key: key);

  final Function(BuildContext, String) handleSubmitPin;

  @override
  _VerifyReferralCodeFormState createState() => _VerifyReferralCodeFormState();
}

class _VerifyReferralCodeFormState extends State<VerifyReferralCodeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _referralCode;
  String _username;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinputDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.1),
      borderRadius: BorderRadius.circular(8),
    );

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
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
              onSubmit: (String pin) => widget.handleSubmitPin(context, pin),
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
          ],
        ),
      ),
    );
  }
}
