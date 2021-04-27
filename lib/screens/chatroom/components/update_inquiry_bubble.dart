import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';

import './service_detail_bubble.dart';

class UpdateInquiryBubble extends StatelessWidget {
  const UpdateInquiryBubble({
    this.message,
    this.isMe = false,
    this.onTapMessage,
  });

  final UpdateInquiryMessage message;
  final bool isMe;
  final Function(ServiceDetailMessage) onTapMessage;

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
            'Jenny 已送出交易邀請',
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
