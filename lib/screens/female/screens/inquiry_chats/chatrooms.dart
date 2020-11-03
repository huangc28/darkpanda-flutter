import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';

import 'components/chatrooms_list.dart';
import 'components/chatroom_grid.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<InquiryChatroomsBloc, InquiryChatroomsState>(
          builder: (context, state) {
            print('DEBUG state ${state.chatrooms}');

            return ChatroomList(
              chatrooms: state.chatrooms,
              onRefresh: () {
                print('DEBUG trigger onRefresh');
              },
              onLoadMore: () {
                print('DEBUG trigger onLoadMore');
              },
              chatroomBuilder: (context, chatroom, ___) {
                // _getChatroomLastMessage(context, chatroom);
                final lastMsg =
                    BlocProvider.of<InquiryChatMessagesBloc>(context)
                        .state
                        .lastMessage(chatroom.channelUUID);

                return ChatroomGrid(
                  onEnterChat: _onEnterChat,
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

  void _onEnterChat() {
    print('DEBUG enterChat');
  }
}
