import 'package:darkpanda_flutter/enums/route_types.dart';
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

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';
import 'service_historical_list.dart';

class Body extends StatefulWidget {
  const Body({
    this.tabController,
    this.incomingServicesStatus,
    this.incomingServices = const [],
  });

  final TabController tabController;

  final AsyncLoadingStatus incomingServicesStatus;

  final List<IncomingService> incomingServices;

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
            'failed to fetch load imcoming service',
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
        return widget.incomingServicesStatus == AsyncLoadingStatus.loading
            ? Row(
                children: [
                  LoadingScreen(),
                ],
              )
            : ServiceChatroomList(
                chatrooms: widget.incomingServices,
                onRefresh: () {
                  print('DEBUG trigger onRefresh');
                },
                onLoadMore: () {
                  print('DEBUG trigger onLoadMore');
                },
                chatroomBuilder: (context, chatroom, ___) {
                  final lastMsg =
                      state.chatroomLastMessage[chatroom.channelUuid];

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
                            routeTypes: RouteTypes.fromIncomingService,
                          ),
                        );
                      },
                      chatroom: chatroom,
                      lastMessage: lastMsg == null ? "" : lastMsg.content,
                    ),
                  );
                },
              );
      },
    );
  }

  Widget historicalTab() {
    return BlocConsumer<LoadHistoricalServiceBloc, LoadHistoricalServiceState>(
      listener: (BuildContext context, LoadHistoricalServiceState state) {
        // Display error in snack bar.
        if (state.status == AsyncLoadingStatus.error) {
          developer.log(
            'failed to fetch load historaical service',
            error: state.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }
      },
      builder: (BuildContext context, LoadHistoricalServiceState state) {
        return state.status == AsyncLoadingStatus.loading
            ? Row(
                children: [
                  LoadingScreen(),
                ],
              )
            : ServiceHistoricalList(
                historicalService: state.services,
                onRefresh: () {
                  print('DEBUG trigger onRefresh');
                },
                onLoadMore: () {
                  print('DEBUG trigger onLoadMore');
                },
              );
      },
    );
  }
}
