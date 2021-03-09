import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/chatroom.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/models/chatroom.dart' as chatroomModel;

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
  @override
  void initState() {
    BlocProvider.of<InquiryChatroomsBloc>(context).add(FetchChatrooms());

    super.initState();
  }

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
                  onEnterChat: (chatroomModel.Chatroom chatroom) =>
                      _onEnterChat(
                    context,
                    chatroom.channelUUID,
                    chatroom.inquiryUUID,
                    chatroom.serviceType,
                  ),
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

  void _onEnterChat(
    BuildContext context,
    String channelUUID,
    String inquiryUUID,
    String serviceType,
  ) {
    // Retrieve inquirer information here

    // Dispatch fetch chatroom messages
    // After messages are fetched, redirect to chatroom.
    Navigator.of(context, rootNavigator: true).pushNamed(
      MainRoutes.chatroom,
      arguments: ChatroomScreenArguments(
        channelUUID: channelUUID,
        inquiryUUID: inquiryUUID,
        serviceType: serviceType,
      ),
    );
  }
}
