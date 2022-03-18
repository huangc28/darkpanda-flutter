import 'dart:async';

import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_historical_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';

import '../bloc/load_incoming_service_bloc.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';
import 'service_historical_list.dart';

class Body extends StatefulWidget {
  const Body({
    this.tabController,
  });

  final TabController tabController;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  Completer<void> _refreshCompleter;

  @override
  initState() {
    super.initState();
    _refreshCompleter = Completer();
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
          _refreshCompleter.completeError(state.error);
          _refreshCompleter = Completer();
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

        if (state.status == AsyncLoadingStatus.done) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (BuildContext context, LoadIncomingServiceState state) {
        return state.status == AsyncLoadingStatus.initial ||
                state.status == AsyncLoadingStatus.loading
            ? Row(
                children: [
                  LoadingScreen(),
                ],
              )
            : ServiceChatroomList(
                chatrooms: state.services,
                onRefresh: () {
                  BlocProvider.of<LoadIncomingServiceBloc>(context)
                      .add(LoadIncomingService());

                  return _refreshCompleter.future;
                },
                onLoadMore: () {
                  BlocProvider.of<LoadIncomingServiceBloc>(context)
                      .add(LoadMoreIncomingService());
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
                        // print('hello world!!');
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
          _refreshCompleter.completeError(state.error);
          _refreshCompleter = Completer();
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

        if (state.status == AsyncLoadingStatus.done) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();
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
                  BlocProvider.of<LoadHistoricalServiceBloc>(context)
                      .add(LoadHistoricalService());
                  return _refreshCompleter.future;
                },
                onLoadMore: () {
                  BlocProvider.of<LoadHistoricalServiceBloc>(context)
                      .add(LoadMoreHistoricalService());
                },
              );
      },
    );
  }
}
