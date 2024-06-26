import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/cancel_service_message.dart';

class CancelServiceBubble extends StatelessWidget {
  const CancelServiceBubble({
    this.message,
    this.isMe = false,
  });

  final CancelServiceMessage message;
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
        children: <Widget>[
          Text(
            isMe ? '你已取消此交易' : '對方已取消此交易',
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
