import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:flutter/material.dart';

class InquiryDetailDialog extends StatelessWidget {
  const InquiryDetailDialog({
    Key key,
    this.inquiryDetail,
  }) : super(key: key);

  final InquiryDetail inquiryDetail;

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
              _titleText(),
              SizedBox(height: 16),
              _inquiryDetail(),
              SizedBox(height: 16),
              _inquiryAmountDetail(),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _rejectButton(context),
                SizedBox(width: 16),
                _payButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _payButton(context) {
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

  Widget _rejectButton(context) {
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

  Widget _inquiryAmountDetail() {
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
                  inquiryDetail.updateInquiryMessage.matchingFee.toString() +
                      'DP',
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

  Widget _inquiryDetail() {
    final durationSplit =
        inquiryDetail.updateInquiryMessage.duration.toString().split(':');
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
                Flexible(
                  child: Text(
                    inquiryDetail.updateInquiryMessage.address,
                    // '臺中市北屯區豐樂路二段158...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(49, 50, 53, 1),
                    ),
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
                Flexible(
                  child: Text(
                    inquiryDetail.updateInquiryMessage.serviceTime.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(49, 50, 53, 1),
                    ),
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
                Flexible(
                  child: Text(
                    inquiryDetail.updateInquiryMessage.duration >
                                Duration(hours: 0, minutes: 1) &&
                            inquiryDetail.updateInquiryMessage.duration <=
                                Duration(hours: 0, minutes: 59)
                        ? '${durationSplit[1]} 分'
                        : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(49, 50, 53, 1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Text(
      inquiryDetail.username + '已向你發送請求',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color.fromRGBO(49, 50, 53, 1),
      ),
      textAlign: TextAlign.center,
    );
  }
}
