import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';

class DisagreeInquiryBubble extends StatelessWidget {
  const DisagreeInquiryBubble({
    this.message,
    this.isMe = false,
  });

  final DisagreeInquiryMessage message;
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
            'Brat 拒絕邀請',
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
