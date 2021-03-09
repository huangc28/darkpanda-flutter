import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';

import './service_detail_bubble.dart';

class ConfirmedServiceBubble extends StatelessWidget {
  const ConfirmedServiceBubble({
    this.message,
    this.isMe = false,
  });

  final ServiceConfirmedMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return ServiceDetailBubble(
      isMe: isMe,
      message: _confirmedServiceToServiceDetail(message),
    );
  }

  ServiceDetailMessage _confirmedServiceToServiceDetail(
      ServiceConfirmedMessage csm) {
    return ServiceDetailMessage(
      content: csm.content,
      from: csm.from,
      to: csm.to,
      createdAt: csm.createdAt,
      price: csm.price,
      duration: csm.duration,
      serviceTime: csm.serviceTime,
      serviceType: csm.serviceType,
    );
  }
}
