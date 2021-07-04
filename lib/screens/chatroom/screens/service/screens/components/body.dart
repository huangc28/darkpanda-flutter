import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/service_list/models/historical_service.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.historicalService,
    @required this.paymentDetail,
    @required this.paymentDetailStatus,
    this.onCancelService,
  }) : super(key: key);

  final HistoricalService historicalService;
  final PaymentDetail paymentDetail;
  final AsyncLoadingStatus paymentDetailStatus;
  final VoidCallback onCancelService;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (widget.paymentDetailStatus == AsyncLoadingStatus.done)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(31, 30, 56, 1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: UserAvatar(widget.historicalService
                                          .chatPartnerAvatarUrl !=
                                      null
                                  ? widget
                                      .historicalService.chatPartnerAvatarUrl
                                  : ''),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildUserInfo(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildServiceDetail(),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.historicalService.chatPartnerUsername != null
                        ? widget.historicalService.chatPartnerUsername
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetail() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(17, 16, 41, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                height: 7.0,
                width: 7.0,
                transform: new Matrix4.identity()
                  ..rotateZ(45 * 3.1415927 / 180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(254, 226, 136, 1),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                '交易明細',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAddressTimeCardInfo(),
          SizedBox(height: 20),
          _buildDpCardInfo(),
          SizedBox(height: 50),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildAddressTimeCardInfo() {
    final durationSplit = widget.paymentDetail.duration.toString().split(':');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEachText(
              'place.png',
              '地址',
              widget.paymentDetail.address != null
                  ? widget.paymentDetail.address
                  : ''),
          SizedBox(height: 15),
          _buildEachText(
              'clock.png',
              '時間',
              widget.paymentDetail.startTime != null
                  ? '${DateFormat("MM/dd/yy, hh: mm a").format(widget.paymentDetail.startTime)}'
                  : ''),
          SizedBox(height: 15),
          if (durationSplit.length > 0)
            _buildEachText(
              'countDown.png',
              '期限',
              widget.paymentDetail.duration > Duration(hours: 0, minutes: 1) &&
                      widget.paymentDetail.duration <=
                          Duration(hours: 0, minutes: 59)
                  ? '${durationSplit[1]} 分'
                  : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
            ),
        ],
      ),
    );
  }

  Widget _buildDpCardInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEachText(
              'pie.png', '小計', '${widget.paymentDetail.matchingFee}DP'),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        if (widget.paymentDetail.hasCommented == false)
          DPTextButton(
            onPressed: widget.onCancelService,
            text: '取消交易',
            theme: DPTextButtonThemes.purple,
          ),
      ],
    );
  }

  Widget _buildEachText(String iconName, String title, String value,
      {Color titleColor, double titleSize, double valueSize}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            child: Image.asset(
              'lib/screens/service_list/assets/$iconName',
            ),
          ),
          SizedBox(width: 10),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueSize != null ? valueSize : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
