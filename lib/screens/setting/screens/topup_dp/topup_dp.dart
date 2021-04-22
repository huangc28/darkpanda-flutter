import 'package:flutter/material.dart';

import 'components/body.dart';
import 'screen_arguements/args.dart';
import 'screens/topup_payment/topup_payment.dart';

class TopupDp extends StatefulWidget {
  const TopupDp({
    this.onPush,
  });

  final Function(String, TopUpDpArguments) onPush;

  @override
  _TopupDpState createState() => _TopupDpState();
}

class _TopupDpState extends State<TopupDp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('購買DP幣'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(onPush: widget.onPush),
    );
  }
}
