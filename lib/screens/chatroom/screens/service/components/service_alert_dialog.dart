import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

class ServiceAlertDialog extends StatelessWidget {
  const ServiceAlertDialog({
    Key key,
    this.content,
    this.onConfirm,
    this.onDismiss,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  final String content;

  ///  Text of confirm button
  final String confirmText;

  /// Text of cancel button
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

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
                content,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: DPTextButton(
                  theme: DPTextButtonThemes.grey,
                  onPressed: () {
                    onDismiss();
                  },
                  text: cancelText,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: DPTextButton(
                  theme: DPTextButtonThemes.purple,
                  onPressed: () {
                    onConfirm();
                  },
                  text: confirmText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
