import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/inquirer_profile_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/body.dart';
import 'screens/direct_search_inquiry/bloc/load_female_list_bloc.dart';

enum SearchInquiryListTabs {
  random,
  specific,
}

typedef OnPushInquiryDetail = void Function(
    String routeName, InquirerProfileArguments args);

class SearchInquiryList extends StatefulWidget {
  const SearchInquiryList({
    Key key,
    this.onPush,
  }) : super(key: key);

  final OnPushInquiryDetail onPush;

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
              BlocProvider.of<LoadFemaleListBloc>(context)
                  .add(LoadFemaleList());
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
        onPush: widget.onPush,
      ),
    );
  }
}
