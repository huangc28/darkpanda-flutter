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
    return ServiceDetailBubble(
      isMe: isMe,
      message: _updateInquiry(message),
      onTapMessage: onTapMessage,
    );
  }

  ServiceDetailMessage _updateInquiry(UpdateInquiryMessage usm) {
    return ServiceDetailMessage(
      content: usm.content,
      from: usm.from,
      to: usm.to,
      createdAt: usm.createdAt,
      price: usm.price,
      duration: usm.duration,
      serviceTime: usm.serviceTime,
      serviceType: usm.serviceType,
    );
  }
}
