import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/start_service_message.dart';

class StartServiceBubble extends StatelessWidget {
  const StartServiceBubble({
    this.message,
    this.isMe = false,
  });

  final StartServiceMessage message;
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
            '服務開始',
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
