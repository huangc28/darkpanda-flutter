import 'package:flutter/material.dart';

import 'components/body.dart';

class SearchInquiry extends StatefulWidget {
  const SearchInquiry({this.onPush});

  final Function(String) onPush;

  @override
  _SearchInquiryState createState() => _SearchInquiryState();
}

class _SearchInquiryState extends State<SearchInquiry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(onPush: widget.onPush),
    );
  }
}
