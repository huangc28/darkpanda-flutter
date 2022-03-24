import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_historical_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/current_service_chatroom_bloc.dart';

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/service_alert_dialog.dart';
import 'package:darkpanda_flutter/screens/rate/rate.dart';
import 'package:darkpanda_flutter/screens/service_list/models/incoming_service.dart';

import '../bloc/load_incoming_service_bloc.dart';

import 'service_chatroom_list.dart';
import 'service_chatroom_grid.dart';
import 'service_expired_dialog.dart';
import 'service_historical_list.dart';

class ServiceListWindow extends StatefulWidget {
  const ServiceListWindow({
    this.tabController,
  });

  final TabController tabController;

  @override
  _ServiceListWindowState createState() => _ServiceListWindowState();
}

class _ServiceListWindowState extends State<ServiceListWindow>
    with SingleTickerProviderStateMixin {
  Completer<void> _refreshCompleter;

  IncomingService incomingService;

  @override
  initState() {
    super.initState();
    _refreshCompleter = Completer();
  }

  _navigateToRating() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute(
      builder: (context) {
        return Rate(
          chatPartnerAvatarURL: incomingService.chatPartnerAvatarUrl,
          chatPartnerUsername: incomingService.chatPartnerUsername,
          serviceUUID: incomingService.serviceUuid,
        );
      },
    ));
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
                  incomingService = chatroom;

                  final lastMsg =
                      state.chatroomLastMessage[chatroom.channelUuid];

                  var serviceStatus = state.service != null
                      ? state.service[chatroom.serviceUuid]
                      : '';

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ServiceChatroomGrid(
                      onEnterChat: (chatroom) {
                        if (serviceStatus == ServiceStatus.expired) {
                          // - Display popup saying service has expired
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ServiceExpiredDialog(
                                    okText: AppLocalizations.of(context).ok,
                                    content: AppLocalizations.of(context)
                                        .serviceExpiredDialog,
                                    onDismiss: () async {
                                      Navigator.pop(context, true);
                                    });
                              });
                        } else if (serviceStatus == ServiceStatus.canceled) {
                          // - Display popup saying the counter part has cancel the service. Showing buttons to comment or leave the chatroom
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: ServiceAlertDialog(
                                      confirmText: AppLocalizations.of(context)
                                          .proceedRating,
                                      cancelText: AppLocalizations.of(context)
                                          .cancelRating,
                                      content: AppLocalizations.of(context)
                                          .serviceCanceledByOtherDialogText(
                                              chatroom.chatPartnerUsername),
                                      onConfirm: () async {
                                        // Clear CurrentServiceChatroomState
                                        // Redirect to commenting page.
                                        BlocProvider.of<
                                                    CurrentServiceChatroomBloc>(
                                                context)
                                            .add(
                                          LeaveCurrentServiceChatroom(),
                                        );
                                        Navigator.of(context).pop();
                                        _navigateToRating();
                                      },
                                      onDismiss: () async {
                                        // Clear CurrentServiceChatroomState
                                        // Reload incoming service
                                        BlocProvider.of<
                                                    CurrentServiceChatroomBloc>(
                                                context)
                                            .add(
                                          LeaveCurrentServiceChatroom(),
                                        );
                                        Navigator.of(context).pop();
                                        BlocProvider.of<
                                                    LoadIncomingServiceBloc>(
                                                context)
                                            .add(LoadIncomingService());
                                      }),
                                );
                              });
                        } else {
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
                        }
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
