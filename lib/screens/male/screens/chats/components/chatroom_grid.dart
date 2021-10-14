import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';

class ChatroomGrid extends StatelessWidget {
  const ChatroomGrid({
    Key key,
    this.chatroom,
    this.onEnterChat,
    this.lastMessage = '',
  }) : super(key: key);

  final Chatroom chatroom;
  final Function(Chatroom) onEnterChat;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEnterChat(chatroom),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
          border: Border.all(
            width: 1,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: UserAvatar(chatroom.avatarURL),
                ),
                Expanded(
                  flex: 3,
                  child: _buildChatInfoBar(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInfoBar() {
    return Row(
      children: [
        Flexible(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatroom.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  lastMessage == null ? '' : lastMessage,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(106, 109, 137, 1),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
