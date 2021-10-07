import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/search_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/direct_search_inquiry.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.tabController,
              children: <Widget>[
                SearchInquiry(),
                DirectSearchInquiry(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
