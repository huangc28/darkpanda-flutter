import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';

class TopupPayment extends StatefulWidget {
  @override
  _TopupPaymentState createState() => _TopupPaymentState();
}

class _TopupPaymentState extends State<TopupPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('購買DP幣'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(31, 30, 56, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                "您總共購買了2000DP",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(254, 226, 136, 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "總金額：",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "2000",
                                style: TextStyle(
                                  fontSize: 46,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "NTD",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image(
                            image: AssetImage(
                                "lib/screens/setting/assets/big_coin.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    InputTextLabel(label: "充值金額"),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 0.5,
                          color: Color.fromRGBO(106, 109, 137, 1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            InputTextLabelWhite(
                              label: "信用卡號",
                            ),
                            SizedBox(height: 15),
                            buildCreditCardNumberInput(),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InputTextLabelWhite(
                                    label: "到期日",
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InputTextLabelWhite(
                                    label: "安全碼",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: buildValidInput(),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: buildCVCInput(),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            DPTextButton(
                              theme: DPTextButtonThemes.purple,
                              onPressed: () {},
                              text: '信用卡付款',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DPTextButton(
                      theme: DPTextButtonThemes.purple,
                      onPressed: () {},
                      text: '通過 Paypal 付款',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCreditCardNumberInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("請輸入您的卡號"),
        ),
      ],
    );
  }

  Widget buildValidInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("月/日"),
        ),
      ],
    );
  }

  Widget buildCVCInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration("請輸入您的安全碼"),
        ),
      ],
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
              color: Color.fromRGBO(254, 226, 136, 1),
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

class InputTextLabelWhite extends StatelessWidget {
  final String label;

  const InputTextLabelWhite({
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

InputDecoration inputDecoration(hintText) {
  return InputDecoration(
    hintText: hintText,
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
