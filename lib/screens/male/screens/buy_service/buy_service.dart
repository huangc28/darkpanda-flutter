import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class BuyService extends StatefulWidget {
  const BuyService({
    this.args,
  });

  final InquiryDetail args;

  @override
  _BuyServiceState createState() => _BuyServiceState();
}

class _BuyServiceState extends State<BuyService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        leadingWidth: 85,
        leading: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(106, 109, 137, 1),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              '聊天',
              style: TextStyle(
                color: Color.fromRGBO(106, 109, 137, 1),
                fontSize: 16,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        title: Text('交易#113'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
        actions: [
          Align(
            child: GestureDetector(
              onTap: () {
                print('幫助');
              },
              child: Text(
                '幫助',
                style: TextStyle(
                  color: Color.fromRGBO(106, 109, 137, 1),
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Body(),
    );
  }
}
