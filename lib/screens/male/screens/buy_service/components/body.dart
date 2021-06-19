import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/screens/male/screens/buy_service/screens/complete_buy_service/complete_buy_service.dart';

import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';

class Body extends StatefulWidget {
  const Body({
    this.args,
  });

  final InquiryDetail args;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                          'https://www.w3schools.com/howto/img_avatar.png',
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
                    // 'Jneey',
                    widget.args.username ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.args.updateInquiryMessage.serviceTime.toString(),
                    // 'Dec 2, 2020 at 00:20 AM',
                    // '${DateFormat("yMMMMd").format()}',
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
          SizedBox(height: 45),
          _buildAddressTimeCardInfo(),
          SizedBox(height: 20),
          _buildDpCardInfo(),
          SizedBox(height: 20),
          _buildMyDpPointInfo(),
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
          _buildEachText(
            'place.png',
            '地址',
            // '臺中市北屯區豐樂路二段158',
            widget.args.updateInquiryMessage.address,
          ),
          SizedBox(height: 15),
          _buildEachText(
            'clock.png',
            '時間',
            widget.args.updateInquiryMessage.serviceTime.toString(),
          ),
          SizedBox(height: 15),
          _buildEachText(
            'countDown.png',
            '期限',
            widget.args.updateInquiryMessage.duration.toString(),
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
          _buildEachText('pie.png', '小計',
              widget.args.updateInquiryMessage.price.toString()),
          SizedBox(height: 15),
          _buildEachText('heart.png', '服務費', '10DP'),
          SizedBox(height: 20),
          _buildEachText('coin.png', '合計', '130DP',
              titleColor: Colors.white, titleSize: 15, valueSize: 16),
        ],
      ),
    );
  }

  Widget _buildMyDpPointInfo() {
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
          Text(
            '我的DP幣：' + widget.args.balance.toString() + 'DP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        DPTextButton(
          onPressed: () {
            print('購買服務');
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => CompleteBuyService(),
              ),
            );
          },
          text: '購買服務',
          theme: DPTextButtonThemes.purple,
        ),
        SizedBox(height: 15),
        DPTextButton(
          onPressed: () {
            print('取消交易');
          },
          text: '取消交易',
          theme: DPTextButtonThemes.pink,
        ),
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
