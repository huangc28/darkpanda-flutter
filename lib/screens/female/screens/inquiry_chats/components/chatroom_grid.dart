import 'package:darkpanda_flutter/components/dp_not_read_circle.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/chatroom.dart';
import 'package:darkpanda_flutter/components/user_avatar.dart';

class ChatroomGrid extends StatelessWidget {
  const ChatroomGrid({
    this.chatroom,
    this.onEnterChat,
    this.lastMessage = '',
    this.isRead,
  });

  final Chatroom chatroom;
  final Function(Chatroom) onEnterChat;
  final String lastMessage;
  final bool isRead;

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
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: UserAvatar(chatroom.avatarURL),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildChatInfoBar(),
                    ),
                  ],
                ),
                if (isRead != null)
                  if (isRead == false) _buildIsReadCircle(),
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
            padding: EdgeInsets.only(right: 15),
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

  Widget _buildIsReadCircle() {
    return Positioned(
      right: 20,
      top: 20,
      child: DPNotReadCircle(),
    );
  }
}
