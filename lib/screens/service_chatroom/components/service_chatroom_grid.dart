import 'package:darkpanda_flutter/screens/service_chatroom/models/incoming_service.dart';
import 'package:darkpanda_flutter/util/time_remaining_since_date.dart';
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
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(31, 30, 56, 1),
        border: Border.all(
          width: 0.5,
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
    DateTime today = DateTime.now();
    today = today.add(Duration(hours: 10));
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
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
                    lastMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateTimeUtil.timeAgoSinceDate(today),
                    style: TextStyle(
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.fromLTRB(4.5, 1, 4.5, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(236, 97, 88, 1),
                    ),
                    child: Text(
                      '1',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
