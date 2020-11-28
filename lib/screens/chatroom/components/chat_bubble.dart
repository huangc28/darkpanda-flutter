import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/message.dart';

/// @TODOs:
///   [ChatBubble] should accept custom text widget. If [Text] widget is not
///   provided, use default [Text] widget instead.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    @required this.message,
    this.isMe = false,
    this.richText,
  });

  final Message message;
  final bool isMe;
  final RichText richText;

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
            child: richText ?? _buildDefaultText(message.content),
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
            child: _buildDefaultText(message.content),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultText(String content) {
    return Text(
      message.content,
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMe ? _buildMineBubble(context) : _buildChatBubble(context);
  }
}
