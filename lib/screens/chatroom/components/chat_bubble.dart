import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    this.message,
    this.isMe = false,
  });

  final Message message;
  final bool isMe;

  Widget _buildMineBubble(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMe ? _buildMineBubble(context) : _buildChatBubble(context);
  }
}
