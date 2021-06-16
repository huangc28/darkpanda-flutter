import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

import 'components/body.dart';
import 'screen_arguements/args.dart';

class TopupDp extends StatefulWidget {
  const TopupDp({
    this.args,
    this.onPush,
  });

  final UpdateInquiryMessage args;
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
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      body: Body(
        onPush: widget.onPush,
        args: widget.args,
      ),
    );
  }
}
