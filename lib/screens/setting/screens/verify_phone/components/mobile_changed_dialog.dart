import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class MobileChangedDialog extends StatelessWidget {
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
                '電話已更新！',
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
            width: MediaQuery.of(context).size.width * 1,
            child: DPTextButton(
              theme: DPTextButtonThemes.purple,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              text: '回到個人信息頁',
            ),
          ),
        ],
      ),
    );
  }
}
