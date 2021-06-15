import 'package:darkpanda_flutter/screens/service_list/bloc/load_historical_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';

import '../models/incoming_service.dart';
import '../bloc/load_incoming_service_bloc.dart';

import '../models/historical_service.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';
import 'service_historical_list.dart';

class Body extends StatefulWidget {
  const Body({
    this.tabController,
    this.incomingServicesStatus,
    this.historicalServicesStatus,
    this.incomingServices = const [],
    this.historicalServices = const [],
  });

  final TabController tabController;

  final AsyncLoadingStatus incomingServicesStatus;
  final AsyncLoadingStatus historicalServicesStatus;

  final List<IncomingService> incomingServices;
  final List<HistoricalService> historicalServices;

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
                historicalTab(),
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
      return widget.incomingServicesStatus == AsyncLoadingStatus.loading
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

  Widget historicalTab() {
    return widget.historicalServicesStatus == AsyncLoadingStatus.loading
        ? LoadingScreen()
        : ServiceHistoricalList(
            historicalService: widget.historicalServices,
            onRefresh: () {
              print('DEBUG trigger onRefresh');
            },
            onLoadMore: () {
              print('DEBUG trigger onLoadMore');
            },
          );
  }
}
