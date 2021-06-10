import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
// import 'package:darkpanda_flutter/models/service_detail_message.dart';

class DisagreeInquiryBubble extends StatelessWidget {
  const DisagreeInquiryBubble({
    this.message,
    this.isMe = false,
    // this.onTapMessage,
  });

  final DisagreeInquiryMessage message;
  final bool isMe;
  // final Function(ServiceDetailMessage) onTapMessage;

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
            'Brat 已拒絕邀請',
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
