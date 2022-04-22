import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';

import 'package:darkpanda_flutter/contracts/chatroom.dart' show InquiryDetail;

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.args,
    this.onGoToServiceChatroom,
  }) : super(key: key);

  final InquiryDetail args;
  final VoidCallback onGoToServiceChatroom;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Image.asset(
                  'lib/screens/male/assets/celebrateBackground.png',
                  width: double.infinity,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(top: 80),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: UserAvatar(""),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '你與${widget.args.username}的交易已成功！',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '見面時間：${DateFormat("MM/dd/yy").format(widget.args.updateInquiryMessage?.serviceTime)}, ${DateFormat("jm").format(widget.args.updateInquiryMessage?.serviceTime)}',
              style: TextStyle(
                color: Color.fromRGBO(106, 109, 137, 1),
                fontSize: 13,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 35,
                left: 20,
                right: 20,
              ),
              child: DPTextButton(
                onPressed: widget.onGoToServiceChatroom,
                text: '繼續聊天',
                theme: DPTextButtonThemes.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
