import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
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
                backgroundImage:
                    widget.historicalService.chatPartnerAvatarUrl == ""
                        ? AssetImage("assets/logo.png")
                        : NetworkImage(
                            widget.historicalService.chatPartnerAvatarUrl),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
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
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "200DP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      RatingBar(
                        initialRating: 3,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 14,
                        ratingWidget: RatingWidget(
                          full: Image.asset(
                            'lib/screens/service_list/assets/rate.png',
                          ),
                          half: Image.asset(
                            'lib/screens/service_list/assets/rate.png',
                          ),
                          empty: Image.asset(
                            'lib/screens/service_list/assets/unrate.png',
                          ),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 2),
                        onRatingUpdate: null,
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
