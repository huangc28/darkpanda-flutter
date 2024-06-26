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
    this.avatarUrl = "",
  });

  final Message message;
  final bool isMe;
  final RichText richText;
  final String avatarUrl;

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
              color: Color.fromRGBO(119, 81, 255, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: richText ?? _buildDefaultText(message.content),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherBubble(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: avatarUrl != ""
                ? NetworkImage(avatarUrl)
                : AssetImage("assets/default_avatar.png"),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 55, 77, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: richText ?? _buildDefaultText(message.content),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultText(String content) {
    return Text(
      message.content ?? '',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMe ? _buildMineBubble(context) : _buildOtherBubble(context);
  }
}
