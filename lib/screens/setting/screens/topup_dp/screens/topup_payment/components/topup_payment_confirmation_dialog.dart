import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class TopupUPaymentConfirmationDialog extends StatelessWidget {
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
                '確定付款？',
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
              theme: DPTextButtonThemes.purple,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              text: '確定',
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: DPTextButton(
              theme: DPTextButtonThemes.grey,
              onPressed: () async {
                Navigator.pop(context, false);
              },
              text: '取消',
            ),
          ),
        ],
      ),
    );
  }
}
