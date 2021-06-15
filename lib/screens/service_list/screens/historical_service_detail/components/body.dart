import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/rate/rate.dart';

import '../../../models/historical_service.dart';

class Body extends StatefulWidget {
  final HistoricalService historicalService;
  const Body({
    Key key,
    @required this.historicalService,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(31, 30, 56, 1),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: UserAvatar(
                            widget.historicalService.chatPartnerAvatarUrl),
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
                    widget.historicalService.chatPartnerUsername,
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
                    // overflow: TextOverflow.ellipsis,
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
          _buildEachText('place.png', '地址', '臺中市北屯區豐樂路二段158'),
          SizedBox(height: 15),
          _buildEachText('clock.png', '時間', '12/18/20，00：20AM'),
          SizedBox(height: 15),
          _buildEachText('countDown.png', '期限', '1小時'),
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
          _buildEachText('pie.png', '小計', '120DP'),
          SizedBox(height: 15),
          _buildEachText('heart.png', '服務費', '10DP'),
          SizedBox(height: 20),
          _buildEachText('coin.png', '合計', '130DP',
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
