import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        child: Column(
          children: <Widget>[
            _buildEachText('pie.png', '小計',
                '${inquiryDetail.updateInquiryMessage.matchingFee}DP'),
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
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        child: Column(
          children: <Widget>[
            _buildEachText(
                'place.png',
                '地址',
                inquiryDetail.updateInquiryMessage.address != null
                    ? inquiryDetail.updateInquiryMessage.address
                    : ''),
            SizedBox(height: 8),
            _buildEachText(
                'clock.png',
                '時間',
                inquiryDetail.updateInquiryMessage.serviceTime != null
                    ? '${DateFormat("MM/dd/yy, hh: mm a").format(inquiryDetail.updateInquiryMessage.serviceTime)}'
                    : ''),
            SizedBox(height: 8),
            if (durationSplit.length > 0)
              _buildEachText(
                'countDown.png',
                '時長',
                inquiryDetail.updateInquiryMessage.duration >
                            Duration(hours: 0, minutes: 1) &&
                        inquiryDetail.updateInquiryMessage.duration <=
                            Duration(hours: 0, minutes: 59)
                    ? '${durationSplit[1]} 分'
                    : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
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

  Widget _buildEachText(String iconName, String title, String value,
      {Color titleColor, double titleSize, double valueSize}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            child: Image.asset(
              'lib/screens/service_list/assets/$iconName',
            ),
          ),
          SizedBox(width: 4),
          Text(
            '${title}:',
            style: TextStyle(
              color: titleColor != null
                  ? titleColor
                  : Color.fromRGBO(106, 109, 137, 1),
              fontSize: titleSize != null ? titleSize : 13,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: valueSize != null ? valueSize : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
