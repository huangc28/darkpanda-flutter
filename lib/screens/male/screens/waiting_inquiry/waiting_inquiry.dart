import 'package:flutter/material.dart';

import 'components/body.dart';

class WaitingInquiry extends StatefulWidget {
  @override
  _WaitingInquiryState createState() => _WaitingInquiryState();
}

class _WaitingInquiryState extends State<WaitingInquiry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
