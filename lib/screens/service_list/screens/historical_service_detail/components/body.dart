import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/models/rate_detail.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/rate/rate.dart';
import '../../../models/historical_service.dart';

class Body extends StatefulWidget {
  final HistoricalService historicalService;
  final PaymentDetail paymentDetail;
  final RateDetail rateDetail;
  final AsyncLoadingStatus paymentDetailStatus;
  final AsyncLoadingStatus rateDetailStatus;
  const Body({
    Key key,
    @required this.historicalService,
    @required this.paymentDetail,
    @required this.paymentDetailStatus,
    this.rateDetail,
    this.rateDetailStatus,
  }) : super(key: key);

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
                              child: UserAvatar(
                                  widget.paymentDetail.pickerAvatarUrl != null
                                      ? widget.paymentDetail.pickerAvatarUrl
                                      : ''),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildUserInfo(),
                            ),
                          ],
                        ),
                        if (widget.rateDetailStatus == AsyncLoadingStatus.done)
                          _buildRateDetail(),
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
                    widget.paymentDetail.pickerUsername != null
                        ? widget.paymentDetail.pickerUsername
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${DateFormat("yMMMMd").format(widget.historicalService.appointmentTime)} at ${DateFormat.jm().format(widget.historicalService.appointmentTime)}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(106, 109, 137, 1),
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

  Widget _buildRateDetail() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 25, top: 10, right: 25),
      padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(31, 30, 56, 1),
        border: Border.all(
          style: BorderStyle.solid,
          width: 0.5,
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '您給予 ${widget.rateDetail.raterUsername} 的評價',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          RatingBar(
            initialRating: double.parse(widget.rateDetail.rating.toString()),
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 14,
            ratingWidget: RatingWidget(
              full: Image.asset(
                'lib/screens/service_list/assets/rate.png',
              ),
              half: Image.asset(
                'lib/screens/service_list/assets/rate.png',
              ),
              empty: Image.asset(
                'lib/screens/service_list/assets/unrate.png',
              ),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 2),
            onRatingUpdate: null,
          ),
        ],
      ),
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
          _buildEachText('pie.png', '小計', '${widget.paymentDetail.price}DP'),
          SizedBox(height: 15),
          _buildEachText('heart.png', '服務費', '0DP'),
          SizedBox(height: 20),
          _buildEachText('coin.png', '合計', '${widget.paymentDetail.price}DP',
              titleColor: Colors.white, titleSize: 15, valueSize: 16),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        DPTextButton(
          onPressed: () {
            print('收據？');
          },
          text: '收據？',
          theme: DPTextButtonThemes.purple,
        ),
        SizedBox(height: 15),
        DPTextButton(
          onPressed: () {
            print('評價對方');
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => Rate(),
              ),
            );
          },
          text: '評價對方',
          theme: DPTextButtonThemes.pink,
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            print('封鎖他');
          },
          child: Text(
            '封鎖他',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEachText(String iconName, String title, String value,
      {Color titleColor, double titleSize, double valueSize}) {
    return Container(
      // height: 30,
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
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: valueSize != null ? valueSize : 15,
            ),
          ),
        ],
      ),
    );
  }
}
