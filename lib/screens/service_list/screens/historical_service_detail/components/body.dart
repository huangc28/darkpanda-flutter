import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/enums/service_cancel_cause.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/models/rate_detail.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import '../../../models/historical_service.dart';
import '../../../mixin/serviceStatusTextProvider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.historicalService,
    @required this.paymentDetail,
    @required this.paymentDetailStatus,
    this.rateDetail,
    this.rateDetailStatus,
    this.onRefreshRateDetail,
    this.onRating,
    this.onBlock,
  }) : super(key: key);

  final HistoricalService historicalService;
  final PaymentDetail paymentDetail;
  final RateDetail rateDetail;
  final AsyncLoadingStatus paymentDetailStatus;
  final AsyncLoadingStatus rateDetailStatus;
  final Function onRefreshRateDetail;
  final VoidCallback onRating;
  final VoidCallback onBlock;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body>
    with SingleTickerProviderStateMixin, ServiceStatusTextProvider {
  String _cancelCause;
  String _gender;
  String _refundStatus = '';

  @override
  void initState() {
    super.initState();

    _getGender().then((value) {
      _gender = value;

      _serviceCancelCause();
    });
  }

  Future<String> _getGender() => SecureStore().readGender();

  void _serviceCancelCause() {
    if (_gender == Gender.male.name) {
      if (widget.historicalService.cancelCause ==
          ServiceCancelCause.girl_cancel_after_appointment_time) {
        _cancelCause = '* 對方在約定時間後取消';

        if (widget.historicalService.refunded == true) {
          _refundStatus = ' - 已退款';
        } else {
          _refundStatus = ' - 未退款';
        }
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.girl_cancel_before_appointment_time) {
        _cancelCause = '* 對方在約定時間前取消';

        if (widget.historicalService.refunded == true) {
          _refundStatus = ' - 已退款';
        } else {
          _refundStatus = ' - 未退款';
        }
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.guy_cancel_before_appointment_time) {
        _cancelCause = '* 您在約定時間前取消';

        if (widget.historicalService.refunded == true) {
          _refundStatus = ' - 已退款';
        } else {
          _refundStatus = ' - 未退款';
        }
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.guy_cancel_after_appointment_time) {
        // No refund needed
        _cancelCause = '* 您在約定時間後取消';
      } else {
        _cancelCause = '';
      }
    } else {
      if (widget.historicalService.cancelCause ==
          ServiceCancelCause.girl_cancel_after_appointment_time) {
        _cancelCause = '* 您在約定時間後取消';
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.girl_cancel_before_appointment_time) {
        _cancelCause = '* 您在約定時間前取消';
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.guy_cancel_before_appointment_time) {
        _cancelCause = '* 對方在約定時間前取消';
      } else if (widget.historicalService.cancelCause ==
          ServiceCancelCause.guy_cancel_after_appointment_time) {
        _cancelCause = '* 對方在約定時間後取消';
      } else {
        _cancelCause = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (widget.paymentDetailStatus == AsyncLoadingStatus.done)
              Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(31, 30, 56, 1),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: _buildUserInfo(),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildServiceStatus(),
                            ),
                          ],
                        ),
                        _buildCancelCause(),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: UserAvatar(
        widget.historicalService.chatPartnerAvatarUrl != null
            ? widget.historicalService.chatPartnerAvatarUrl
            : '',
      ),
    );
  }

  Widget _buildServiceStatus() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: geTextByServiceStatus(
                          context,
                          widget.historicalService.status,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelCause() {
    return widget.historicalService.cancelCause != ServiceCancelCause.none &&
            widget.historicalService.cancelCause !=
                ServiceCancelCause.payment_failed
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _cancelCause,
                  style: TextStyle(
                    color: Color.fromRGBO(106, 109, 137, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        : Container();
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
        children: <Widget>[
          Text(
            '您給予 ${widget.historicalService.chatPartnerUsername} 的評價',
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
          // _buildDpCardInfo(),
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
        children: <Widget>[
          _buildEachText(
            '',
            '服務',
            widget.paymentDetail.serviceType != null
                ? widget.paymentDetail.serviceType
                : '',
            icon: Icons.article,
          ),
          SizedBox(height: 15),
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
              '時長',
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
    final price =
        widget.paymentDetail.price == null ? 0 : widget.paymentDetail.price;

    // final total = price + widget.paymentDetail.matchingFee;

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
          _buildEachText('pie.png', '服務費', '${price}'),
          // SizedBox(height: 15),
          // _buildEachText(
          //     'heart.png', '媒合費', '${widget.paymentDetail.matchingFee}DP'),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: <Widget>[
        Container(),
        if (widget.paymentDetail.hasCommented == false)
          DPTextButton(
            onPressed: widget.onRating,
            text: '評價對方',
            theme: DPTextButtonThemes.pink,
          ),
        SizedBox(height: 14),
        if (widget.paymentDetail.hasBlocked == false)
          GestureDetector(
            onTap: widget.onBlock,
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

  Widget _buildEachText(
    String iconName,
    String title,
    String value, {
    Color titleColor,
    double titleSize,
    double valueSize,
    FontWeight fontWeight = FontWeight.normal,
    IconData icon,
  }) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            child: iconName != ''
                ? Image.asset(
                    'lib/screens/service_list/assets/$iconName',
                  )
                : CircleAvatar(
                    backgroundColor: Color.fromRGBO(77, 70, 106, 1),
                    child: Icon(
                      icon,
                      color: Color.fromRGBO(155, 127, 255, 1),
                      size: 15.0,
                    ),
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
              fontWeight: fontWeight,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueSize != null ? valueSize : 15,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
