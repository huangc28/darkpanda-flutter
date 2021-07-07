import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class CancelServiceConfirmationDialog extends StatelessWidget {
  const CancelServiceConfirmationDialog({
    Key key,
    this.matchingFee,
  }) : super(key: key);

  final int matchingFee;

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
                '對方將可以給你評價，確定取消？',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '若取消交易，本平台另收取的 ${matchingFee}DP 服務費不能退還',
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
              text: '不取消',
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: DPTextButton(
              theme: DPTextButtonThemes.purple,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              text: '確定取消',
            ),
          ),
        ],
      ),
    );
  }
}