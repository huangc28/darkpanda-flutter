import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:darkpanda_flutter/util/convertZeroDecimalToInt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/service_list/models/historical_service.dart';
import 'package:darkpanda_flutter/models/service_details.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.historicalService,
    @required this.paymentDetail,
    this.serviceDetails,
    @required this.paymentDetailStatus,
    this.onCancelService,
    this.cancelServiceStatus,
  }) : super(key: key);

  final HistoricalService historicalService;
  final PaymentDetail paymentDetail;
  final ServiceDetails serviceDetails;
  final AsyncLoadingStatus paymentDetailStatus;
  final VoidCallback onCancelService;
  final AsyncLoadingStatus cancelServiceStatus;

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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: UserAvatar(widget.historicalService
                                            .chatPartnerAvatarUrl !=
                                        null
                                    ? widget
                                        .historicalService.chatPartnerAvatarUrl
                                    : ''),
                              ),
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
            'pie.png',
            '服務費',
            '${convertZeroDecimalToInt(widget.serviceDetails.price)}',
          ),
          // SizedBox(height: 15),
          // _buildEachText(
          //     'heart.png', '媒合費', '${widget.serviceDetails.matchingFee}DP'),
        ],
      ),
    );
  }

  Widget _buildButton() {
    bool buttonIsDisabled = false;

    if (widget.cancelServiceStatus == AsyncLoadingStatus.loading) {
      buttonIsDisabled = true;
    } else {
      buttonIsDisabled = false;
    }

    if (widget.historicalService.status == ServiceStatus.fulfilling.name) {
      buttonIsDisabled = true;
    }

    if (widget.historicalService.status == ServiceStatus.completed.name) {
      buttonIsDisabled = true;
    }

    return Column(
      children: <Widget>[
        if (widget.paymentDetail.hasCommented == false)
          DPTextButton(
            // When disabled is true:
            // 1. History service status is fulfilling
            // 2. Loading cancel service cause
            // When loading is true:
            // 1. Loading cancel service cause
            disabled: buttonIsDisabled,
            loading: widget.cancelServiceStatus == AsyncLoadingStatus.loading,
            onPressed: widget.onCancelService,
            text:
                widget.historicalService.status == ServiceStatus.fulfilling.name
                    ? '服務進行中，無法取消交易'
                    : widget.historicalService.status ==
                            ServiceStatus.completed.name
                        ? '服務已結束'
                        : '取消交易',
            theme: DPTextButtonThemes.purple,
          ),
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
        children: [
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
