import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/service_detail_message.dart';

import 'chat_bubble.dart';

/// We need to compose service detail message content from
/// model [ServiceDetailMessage].
class ServiceDetailBubble extends StatelessWidget {
  const ServiceDetailBubble({
    this.message,
    this.isMe = false,
    this.onTapMessage,
  });

  final ServiceDetailMessage message;
  final bool isMe;
  final Function(ServiceDetailMessage) onTapMessage;

  @override
  Widget build(BuildContext context) {
    /// Build message content. Pass the message content
    /// to [ChatBubble] widget.
    /// Data that need to be included in the message:
    ///   - Price
    ///   - Service time
    ///   - Duration
    ///   - Service type
    return GestureDetector(
      onTap: () => onTapMessage(message),
      child: _buildChatBubble(message),
    );
  }

  Widget _buildChatBubble(ServiceDetailMessage message) {
    return ChatBubble(
      isMe: isMe,
      message: message,
      richText: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
          children: [
            TextSpan(
              style: TextStyle(
                height: 1.3,
              ),
            ),
            TextSpan(
              text: '${message.serviceType} \n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: 'Price: ${message.price} \n',
            ),
            TextSpan(
              text:
                  'Service date: ${message.serviceTime.year} / ${message.serviceTime.month} / ${message.serviceTime.day} \n',
            ),
            TextSpan(
              text:
                  'Service time: ${message.serviceTime.hour}:${message.serviceTime.minute}\n',
            ),
            TextSpan(
              text: 'duration: ${message.duration} minutes',
            ),
          ],
        ),
      ),
    );
  }
}
