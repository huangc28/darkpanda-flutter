import 'package:darkpanda_flutter/screens/service_chatroom/models/incoming_service.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';

class ServiceChatroomGrid extends StatelessWidget {
  const ServiceChatroomGrid({
    this.chatroom,
    this.onEnterChat,
    this.lastMessage = '',
  });

  final IncomingService chatroom;
  final Function(IncomingService) onEnterChat;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          GestureDetector(
            onTap: () => onEnterChat(chatroom),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: UserAvatar(chatroom.avatarUrl),
                ),
                Expanded(
                  flex: 3,
                  child: _buildChatInfoBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInfoBar() {
    return Row(
      children: [
        Container(
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
                lastMessage,
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(106, 109, 137, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
