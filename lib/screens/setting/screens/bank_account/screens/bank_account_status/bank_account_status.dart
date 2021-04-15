import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class BankAccountStatus extends StatefulWidget {
  @override
  _BankAccountStatusState createState() => _BankAccountStatusState();
}

class _BankAccountStatusState extends State<BankAccountStatus> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 26, 20, 0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.5,
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      InputTextLabel(
                        label: "户名：",
                      ),
                      SizedBox(height: 10),
                      InputTextLabel(
                        label: "銀行：",
                      ),
                      SizedBox(height: 10),
                      InputTextLabel(
                        label: "帳號：",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "驗證中",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(254, 226, 136, 1),
                ),
              ),
              buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVerifyButton() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 2.3,
      ),
      // padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 44,
          child: DPTextButton(
            theme: DPTextButtonThemes.purple,
            onPressed: () {},
            text: '帳戶設定',
          ),
        ),
      ),
    );
  }
}

class InputTextLabel extends StatelessWidget {
  final String label;

  const InputTextLabel({
    Key key,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 7.0,
          width: 7.0,
          transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
            fontSize: 18,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Jenny',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
