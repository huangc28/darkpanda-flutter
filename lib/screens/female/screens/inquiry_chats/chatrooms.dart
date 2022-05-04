import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart';
import 'package:darkpanda_flutter/layouts/system_ui_overlay_layout.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/models/chatroom.dart' as chatroomModel;
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';

import 'components/chatrooms_list.dart';
import 'components/chatroom_grid.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({
    this.onPush,
  });

  final OnPush onPush;

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  InquiryChatroomsBloc _inquiryChatroomsBloc;
  Completer<void> _refreshCompleter;

  /// Emit flutter bloc event in lifecycle `Dispose` https://github.com/felangel/bloc/issues/588.
  @override
  void initState() {
    _refreshCompleter = Completer();
    _inquiryChatroomsBloc = BlocProvider.of<InquiryChatroomsBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _inquiryChatroomsBloc.add(ClearInquiryChatList());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   body:
        SystemUiOverlayLayout(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // Inquiry chatrooms title
            _buildHeader(),
            BlocConsumer<InquiryChatroomsBloc, InquiryChatroomsState>(
              listener: (context, state) {
                // Display error in snack bar.
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
                      BlocProvider.of<InquiryChatroomsBloc>(context)
                          .add(FetchChatrooms());

                      return _refreshCompleter.future;
                    },
                    onLoadMore: () {
                      BlocProvider.of<InquiryChatroomsBloc>(context)
                          .add(LoadMoreChatrooms());
                    },
                    chatroomBuilder: (context, chatroom, ___) {
                      final lastMsg =
                          state.chatroomLastMessage[chatroom.channelUUID];

                      // Loading inquirier info before proceeding to chatroom.
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: ChatroomGrid(
                          onEnterChat: (chatroomModel.Chatroom chatroom) {
                            // Navigate to inquiry_chat_room.
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushReplacementNamed(
                              MainRoutes.femaleInquiryChatroom,
                              arguments: FemaleInquiryChatroomScreenArguments(
                                channelUUID: chatroom.channelUUID,
                                inquiryUUID: chatroom.inquiryUUID,
                                counterPartUUID: chatroom.inquirerUUID,
                                serviceType: chatroom.serviceType,
                                routeTypes: RouteTypes.fromInquiryChats,
                                serviceUUID: chatroom.serviceUUID,
                              ),
                            );
                          },
                          chatroom: chatroom,

                          // Chatroom grid displays the latest message of a chatroom.
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
      // ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
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
            '洽談聊天列表',
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
