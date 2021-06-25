import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/incoming_service.dart';

class ChatCard extends StatefulWidget {
  final IncomingService chat;
  final VoidCallback press;

  const ChatCard({
    Key key,
    @required this.chat,
    @required this.press,
  }) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20 * 0.40,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(255, 255, 255, 0.1),
            border: Border.all(
              style: BorderStyle.solid,
              width: 0.5,
              color: Color.fromRGBO(106, 109, 137, 1),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.chat.chatPartnerAvatarUrl == ""
                    ? AssetImage("assets/logo.png")
                    : NetworkImage(widget.chat.chatPartnerAvatarUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chat.chatPartnerUsername,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "chat.lastMessage",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(106, 109, 137, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "還有10分鐘",
                        // formatter.format(widget.chat.appointmentTime),
                        style: TextStyle(
                          color: Color.fromRGBO(106, 109, 137, 1),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(4.5, 1, 4.5, 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(236, 97, 88, 1),
                        ),
                        child: Text(
                          "1",
                          // chat.unRead.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
