import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/historical_service.dart';

class HistoryCard extends StatefulWidget {
  final HistoricalService historicalService;
  final VoidCallback press;

  const HistoryCard({
    Key key,
    @required this.historicalService,
    @required this.press,
  }) : super(key: key);

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(31, 30, 56, 1),
          border: Border.all(
            width: 0.5,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child:
                      UserAvatar(widget.historicalService.chatPartnerAvatarUrl),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.historicalService.chatPartnerUsername,
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
                        '${DateFormat("yMMMMd").format(widget.historicalService.appointmentTime)} at ${DateFormat.jm().format(widget.historicalService.appointmentTime)}',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
