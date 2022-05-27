import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/payment_completed_message.dart';

class PaymentCompletedBubble extends StatelessWidget {
  const PaymentCompletedBubble({
    this.message,
    this.isMe = false,
  });

  final PaymentCompletedMessage message;
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
            message.username + ' 已完成付款',
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
