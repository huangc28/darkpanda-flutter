import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/chatroom_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/chatroom.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/models/incoming_service.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/service_chatroom/bloc/load_incoming_service_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  LoadIncomingServiceBloc loadIncomingServiceBloc =
      new LoadIncomingServiceBloc();
  TabController _tabController;
  List<IncomingService> incomingService;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    BlocProvider.of<LoadIncomingServiceBloc>(context)
        .add(LoadIncomingService());
  }

  @override
  void dispose() {
    loadIncomingServiceBloc.add(ClearIncomingServiceState());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                comingTab(),
                Text("456"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget comingTab() {
    return BlocConsumer<LoadIncomingServiceBloc, LoadIncomingServiceState>(
      listener: (BuildContext context, LoadIncomingServiceState state) {
        // Display error in snack bar.
        if (state.status == AsyncLoadingStatus.error) {
          developer.log(
            'failed to fetch inquiry chatroom',
            error: state.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }
      },
      builder: (BuildContext context, LoadIncomingServiceState state) {
        if (state.status == AsyncLoadingStatus.initial ||
            state.status == AsyncLoadingStatus.loading) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        } else if (state.status == AsyncLoadingStatus.done) {
          // incomingService = state.services;
          return ServiceChatroomList(
            chatrooms: state.services,
            onRefresh: () {
              print('DEBUG trigger onRefresh');
            },
            onLoadMore: () {
              print('DEBUG trigger onLoadMore');
            },
            chatroomBuilder: (context, chatroom, ___) {
              final lastMsg = state.chatroomLastMessage[chatroom.channelUuid];

              return Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                ),
                child: ServiceChatroomGrid(
                  onEnterChat: (chatroom) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(
                      MainRoutes.chatroom,
                      arguments: ChatroomScreenArguments(
                        channelUUID: chatroom.channelUuid,
                        inquiryUUID: chatroom.inquiryUuid,
                        counterPartUUID: chatroom.inquirerUuid,
                        serviceType: chatroom.serviceUuid,
                        chatroomType: ChatroomTypes.service,
                        serviceUUID: chatroom.serviceUuid,
                      ),
                    );
                  },
                  chatroom: chatroom,
                  lastMessage: lastMsg == null ? "" : lastMsg.content,
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
