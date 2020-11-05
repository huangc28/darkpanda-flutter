import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';

import 'components/chatrooms_list.dart';
import 'components/chatroom_grid.dart';
import './routes.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms({
    this.onPush,
  });

  final OnPush onPush;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<InquiryChatroomsBloc, InquiryChatroomsState>(
          builder: (context, state) {
            return ChatroomList(
              chatrooms: state.chatrooms,
              onRefresh: () {
                print('DEBUG trigger onRefresh');
              },
              onLoadMore: () {
                print('DEBUG trigger onLoadMore');
              },
              chatroomBuilder: (context, chatroom, ___) {
                final lastMsg =
                    BlocProvider.of<InquiryChatMessagesBloc>(context)
                        .state
                        .lastMessage(chatroom.channelUUID);

                return ChatroomGrid(
                  onEnterChat: (String channelUUID) =>
                      _onEnterChat(context, channelUUID),
                  chatroom: chatroom,
                  lastMessage: lastMsg.content,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _onEnterChat(BuildContext context, String channelUUID) {
    // Displatch fetch chatroom messages
    // After messages are fetched, redirect to chatroom.
    // BlocProvider.of<InquiryChatMessagesBloc>(context).add(
    //   FetchHist(
    //     channelUUID: channelUUID,
    //   ),
    // );
  }
}
