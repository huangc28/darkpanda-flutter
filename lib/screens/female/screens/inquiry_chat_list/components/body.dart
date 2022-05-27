import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show FetchInquiryChatroomBloc, APIClient;
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chats/chatrooms.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/direct_inquiry_request.dart';

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.tabController,
              children: <Widget>[
                BlocProvider(
                  create: (context) => FetchInquiryChatroomBloc(
                    apis: APIClient(),
                    inquiryChatroomBloc:
                        BlocProvider.of<InquiryChatroomsBloc>(context),
                  ),
                  child: DirectInquiryRequest(
                    onTabBarChanged: _handleTabBarChange,
                  ),
                ),
                ChatRooms(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _handleTabBarChange(int index) {
    widget.tabController.animateTo(index);

    BlocProvider.of<InquiryChatroomsBloc>(context).add(FetchChatrooms());
  }
}
