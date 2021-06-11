import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/quit_chatroom_message.dart';

class QuitChatroomBubble extends StatelessWidget {
  const QuitChatroomBubble({
    this.message,
    this.isMe = false,
  });

  final QuitChatroomMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '對方已離開聊天室',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(106, 109, 137, 1),
            ),
          ),
        ],
      ),
    );
  }
}
