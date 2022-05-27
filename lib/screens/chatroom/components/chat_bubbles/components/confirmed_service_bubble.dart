import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/service_confirmed_message.dart';

class ConfirmedServiceBubble extends StatelessWidget {
  const ConfirmedServiceBubble({
    this.message,
    this.isMe = false,
  });

  final ServiceConfirmedMessage message;
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
            message.username + ' 已接受邀請',
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
