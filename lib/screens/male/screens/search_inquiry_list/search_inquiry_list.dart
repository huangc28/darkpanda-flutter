import 'package:flutter/material.dart';

import 'components/body.dart';

enum SearchInquiryListTabs {
  random,
  specific,
}

class SearchInquiryList extends StatefulWidget {
  const SearchInquiryList({Key key}) : super(key: key);

  @override
  _SearchInquiryListState createState() => _SearchInquiryListState();
}

class _SearchInquiryListState extends State<SearchInquiryList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static const _tabs = [
    SearchInquiryListTabs.random,
    SearchInquiryListTabs.specific,
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: TabBar(
          onTap: (index) {
            if (_tabs[index] == SearchInquiryListTabs.random) {
              // BlocProvider.of<LoadIncomingServiceBloc>(context)
              // .add(LoadIncomingService());
            }

            if (_tabs[index] == SearchInquiryListTabs.specific) {
              // BlocProvider.of<LoadHistoricalServiceBloc>(context)
              // .add(LoadHistoricalService());
            }
          },
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 0.53,
          ),
          tabs: [
            Tab(text: '隨機配對'),
            Tab(text: '指定配對'),
          ],
        ),
      ),
      body: Body(
        tabController: _tabController,
      ),
    );
  }
}
