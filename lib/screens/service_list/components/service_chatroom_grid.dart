import 'package:darkpanda_flutter/components/dp_not_read_circle.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/util/time_remaining_since_date.dart';

import '../models/incoming_service.dart';

class ServiceChatroomGrid extends StatelessWidget {
  const ServiceChatroomGrid({
    this.chatroom,
    this.onEnterChat,
    this.lastMessage = '',
    this.isRead,
  });

  final IncomingService chatroom;
  final Function(IncomingService) onEnterChat;
  final String lastMessage;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEnterChat(chatroom),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(31, 30, 56, 1),
          border: Border.all(
            width: 0.5,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: UserAvatar(chatroom.chatPartnerAvatarUrl),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildChatInfoBar(),
                    ),
                  ],
                ),
                if (isRead != null)
                  if (isRead == false) _buildIsReadCircle(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInfoBar() {
    DateTime today = DateTime.now();
    today = today.add(Duration(hours: 10));
    return Row(
      children: <Widget>[
        Expanded(
          // flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    chatroom.chatPartnerUsername,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          // flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  chatroom.status == ServiceStatus.fulfilling.name
                      ? Text(
                          '已開始',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      : Container(),
                  Text(
                    chatroom.status == ServiceStatus.fulfilling.name
                        ? ''
                        : DateTimeUtil.timeAgoSinceDate(
                            chatroom.appointmentTime),
                    style: TextStyle(
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIsReadCircle() {
    return Positioned(
      right: 15,
      top: 20,
      child: DPNotReadCircle(),
    );
  }
}
