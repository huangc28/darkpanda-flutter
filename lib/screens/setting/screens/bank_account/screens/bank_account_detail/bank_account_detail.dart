import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class BankAccountDetail extends StatefulWidget {
  @override
  _BankAccountDetailState createState() => _BankAccountDetailState();
}

class _BankAccountDetailState extends State<BankAccountDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              InputTextLabel(label: "帳戶名稱"),
              SizedBox(height: 20),
              buildBankNameInput(),
              SizedBox(height: 24),
              InputTextLabel(label: "銀行代碼"),
              SizedBox(height: 20),
              buildBankNumberInput(),
              SizedBox(height: 24),
              InputTextLabel(label: "銀行賬號"),
              SizedBox(height: 20),
              buildBankAccountNumberInput(),
              buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBankNameInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildBankNumberInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildBankAccountNumberInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildVerifyButton() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 4,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 44,
          child: DPTextButton(
            theme: DPTextButtonThemes.purple,
            onPressed: () {},
            text: '驗證帳戶',
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
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

InputDecoration inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(255, 255, 255, 0.1),
    labelStyle: TextStyle(color: Colors.white),
    // hintText: 'Enter Username',
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
  );
}
