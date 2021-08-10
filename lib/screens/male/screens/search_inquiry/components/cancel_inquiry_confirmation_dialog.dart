import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class CancelInquiryConfirmationDialog extends StatelessWidget {
  const CancelInquiryConfirmationDialog({
    Key key,
    this.title,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  final String title;
  final String onCancel;
  final String onConfirm;

  @override
  Widget build(BuildContext context) {
    return ButtonBarTheme(
      data: ButtonBarThemeData(
        alignment: MainAxisAlignment.center,
      ),
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: DPTextButton(
              theme: DPTextButtonThemes.grey,
              onPressed: () async {
                Navigator.pop(context, false);
              },
              text: onCancel,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: DPTextButton(
              theme: DPTextButtonThemes.purple,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              text: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
