import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';

class ChatroomGrid extends StatelessWidget {
  const ChatroomGrid({
    this.chatroom,
    this.onEnterChat,
    this.lastMessage = '',
  });

  final Chatroom chatroom;
  final ValueChanged<String> onEnterChat;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () => onEnterChat(chatroom.channelUUID),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: UserAvatar(chatroom.avatarURL),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 3,
                child: _buildChatInfoBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInfoBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cWidth = constraints.maxWidth >= 300 ? 320.0 : 220.0;

        return Row(
          children: [
            Container(
              width: cWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatroom.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(lastMessage),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
