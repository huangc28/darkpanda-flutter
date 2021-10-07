import 'package:flutter/material.dart';

import 'components/body.dart';

class DirectSearchInquiry extends StatefulWidget {
  const DirectSearchInquiry({Key key}) : super(key: key);

  @override
  _DirectSearchInquiryState createState() => _DirectSearchInquiryState();
}

class _DirectSearchInquiryState extends State<DirectSearchInquiry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Body(),
    );
  }
}
