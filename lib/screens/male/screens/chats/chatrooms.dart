import 'dart:async';

import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/layouts/system_ui_overlay_layout.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';

import 'package:darkpanda_flutter/bloc/get_inquiry_bloc.dart';
import './bloc/load_direct_inquiry_chatrooms_bloc.dart';

import 'components/chatroom_grid.dart';
import 'components/chatrooms_list.dart';
import 'screen_arguments/direct_chatroom_screen_arguments.dart';

class Chatrooms extends StatefulWidget {
  const Chatrooms({Key key}) : super(key: key);

  @override
  _ChatroomsState createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  LoadDirectInquiryChatroomsBloc _loadDirectInquiryChatroomsBloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer();
    _loadDirectInquiryChatroomsBloc =
        BlocProvider.of<LoadDirectInquiryChatroomsBloc>(context);

    _loadDirectInquiryChatroomsBloc.add(FetchDirectInquiryChatrooms());
  }

  @override
  void dispose() {
    _loadDirectInquiryChatroomsBloc.add(ClearDirectInquiryChatList());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SystemUiOverlayLayout(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _buildHeader(),
              BlocConsumer<LoadDirectInquiryChatroomsBloc,
                  LoadDirectInquiryChatroomsState>(
                listener: (context, state) {
                  if (state.status == AsyncLoadingStatus.error) {
                    _refreshCompleter.completeError(state.error);
                    _refreshCompleter = Completer();
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

                  if (state.status == AsyncLoadingStatus.done) {
                    _refreshCompleter.complete();
                    _refreshCompleter = Completer();
                  }
                },
                builder: (context, state) {
                  if (state.status == AsyncLoadingStatus.loading ||
                      state.status == AsyncLoadingStatus.initial) {
                    return LoadingScreen();
                  }

                  return Expanded(
                    child: ChatroomList(
                      chatrooms: state.chatrooms,
                      onRefresh: () {
                        BlocProvider.of<LoadDirectInquiryChatroomsBloc>(context)
                            .add(FetchDirectInquiryChatrooms());

                        return _refreshCompleter.future;
                      },
                      onLoadMore: () {
                        BlocProvider.of<LoadDirectInquiryChatroomsBloc>(context)
                            .add(LoadMoreChatrooms());
                      },
                      chatroomBuilder: (context, chatroom, ____) {
                        final lastMsg =
                            state.chatroomLastMessage[chatroom.channelUUID];

                        return Container(
                          margin: EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: ChatroomGrid(
                            onEnterChat: (Chatroom chatroom) {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              )
                                  .pushNamed(
                                MainRoutes.directChatroom,
                                arguments: DirectChatroomScreenArguments(
                                  channelUUID: chatroom.channelUUID,
                                  inquiryUUID: chatroom.inquiryUUID,
                                  counterPartUUID: chatroom.pickerUUID,
                                  serviceUUID: chatroom.serviceUUID,
                                  routeTypes: RouteTypes.fromMaleChats,
                                ),
                              )
                                  .then((value) {
                                if (value) {
                                  // Refresh chatroom list after user back from exit chatroom
                                  BlocProvider.of<
                                              LoadDirectInquiryChatroomsBloc>(
                                          context)
                                      .add(FetchDirectInquiryChatrooms());
                                }
                              });
                            },
                            chatroom: chatroom,
                            lastMessage: lastMsg?.content,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 16,
        left: 16,
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '聊天列表',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
