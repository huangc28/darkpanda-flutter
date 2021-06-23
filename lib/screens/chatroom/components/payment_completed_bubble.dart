import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/payment_completed_message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';

class PaymentCompletedBubble extends StatelessWidget {
  const PaymentCompletedBubble({
    this.message,
    this.isMe = false,
    this.onTapMessage,
  });

  final PaymentCompletedMessage message;
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
            'Brat 已完成付款',
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
