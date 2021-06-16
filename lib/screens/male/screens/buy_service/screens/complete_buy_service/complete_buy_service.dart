import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteBuyService extends StatefulWidget {
  const CompleteBuyService();

  @override
  _CompleteBuyServiceState createState() => _CompleteBuyServiceState();
}

class _CompleteBuyServiceState extends State<CompleteBuyService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('支付'),
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
