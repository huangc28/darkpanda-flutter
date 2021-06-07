import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';

import '../models/incoming_service.dart';
import '../bloc/load_incoming_service_bloc.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';

class Body extends StatefulWidget {
  const Body({
    this.tabController,
    this.loadingStatus,
    this.incomingServices = const [],
    this.historicalServices = const [],
  });

  final TabController tabController;
  final AsyncLoadingStatus loadingStatus;

  final List<IncomingService> incomingServices;
  final List<IncomingService> historicalServices;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: widget.tabController,
              children: <Widget>[
                comingTab(),
                Text('456', style: TextStyle(color: Colors.white)),
                // Text("456"),
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
    }, builder: (BuildContext context, LoadIncomingServiceState state) {
      return widget.loadingStatus == AsyncLoadingStatus.loading
          ? LoadingScreen()
          : ServiceChatroomList(
              chatrooms: widget.incomingServices,
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
                        MainRoutes.serviceChatroom,
                        arguments: ServiceChatroomScreenArguments(
                          channelUUID: chatroom.channelUuid,
                          inquiryUUID: chatroom.inquiryUuid,
                          counterPartUUID: chatroom.chatPartnerUserUuid,
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
    });
  }
}
