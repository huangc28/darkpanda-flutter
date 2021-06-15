import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:flutter/material.dart';

class InquiryDetailDialog extends StatelessWidget {
  const InquiryDetailDialog({Key key, this.message}) : super(key: key);

  final UpdateInquiryMessage message;

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
              titleText(),
              SizedBox(height: 16),
              inquiryDetail(),
              SizedBox(height: 16),
              inquiryAmountDetail(),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                rejectButton(context),
                SizedBox(width: 16),
                payButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget payButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: DPTextButton(
        theme: DPTextButtonThemes.purple,
        onPressed: () async {
          Navigator.pop(context, true);
        },
        text: '去支付',
      ),
    );
  }

  Widget rejectButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: DPTextButton(
        theme: DPTextButtonThemes.grey,
        onPressed: () async {
          Navigator.pop(context, false);
        },
        text: '拒絕',
      ),
    );
  }

  Widget inquiryAmountDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(239, 239, 244, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 145, 155, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '小計：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(141, 145, 155, 1),
                  ),
                ),
                Text(
                  message.price.toString() + 'DP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 145, 155, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '服務費：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(141, 145, 155, 1),
                  ),
                ),
                Text(
                  '10DP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(49, 50, 53, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '合計：',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
                Text(
                  '130DP',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inquiryDetail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(239, 239, 244, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 145, 155, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '地址：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(141, 145, 155, 1),
                  ),
                ),
                Text(
                  '臺中市北屯區豐樂路二段158...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 145, 155, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '時間：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(141, 145, 155, 1),
                  ),
                ),
                Text(
                  message.serviceTime.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: <Widget>[
                Container(
                  height: 7.0,
                  width: 7.0,
                  transform: new Matrix4.identity()
                    ..rotateZ(45 * 3.1415927 / 180),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(141, 145, 155, 1),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '期限：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(141, 145, 155, 1),
                  ),
                ),
                Text(
                  message.duration.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(49, 50, 53, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Text(
      'Jenny已向你發送請求',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color.fromRGBO(49, 50, 53, 1),
      ),
      textAlign: TextAlign.center,
    );
  }
}
