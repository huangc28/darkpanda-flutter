import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/bloc/load_direct_inquiry_request_bloc.dart';

import 'components/body.dart';

enum InquiryChatListTabs {
  request,
  chat,
}

class InquiryChatList extends StatefulWidget {
  const InquiryChatList({Key key}) : super(key: key);

  @override
  _InquiryChatListState createState() => _InquiryChatListState();
}

class _InquiryChatListState extends State<InquiryChatList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static const _tabs = [
    InquiryChatListTabs.request,
    InquiryChatListTabs.chat,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: TabBar(
          onTap: (index) {
            if (_tabs[index] == InquiryChatListTabs.request) {
              BlocProvider.of<LoadDirectInquiryRequestBloc>(context)
                  .add(FetchDirectInquiries());
            }

            if (_tabs[index] == InquiryChatListTabs.chat) {
              BlocProvider.of<InquiryChatroomsBloc>(context)
                  .add(FetchChatrooms());
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
            Tab(text: '聊天請求'),
            Tab(text: '聊天室'),
          ],
        ),
      ),
      body: Body(
        tabController: _tabController,
      ),
    );
  }
}
