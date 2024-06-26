import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/service_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../mixin/serviceStatusTextProvider.dart';
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

class _HistoryCardState extends State<HistoryCard>
    with ServiceStatusTextProvider {
  final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');

  // TODO Text should be displayed via i10n.
  // final Map<String, String> serviceStatusContentMap = {
  //   ServiceStatus.canceled.name: "已取消",
  //   ServiceStatus.completed.name: "已完成",
  //   ServiceStatus.expired.name: "已過期",
  //   ServiceStatus.payment_failed.name: "付款失敗",
  // };

  // Text _buildServiceStatusText(
  //   String serviceStatus,
  // ) {
  //   String text = serviceStatusContentMap[serviceStatus];
  //   Color color = Colors.white;
  //   if (serviceStatus == ServiceStatus.canceled.name ||
  //       serviceStatus == ServiceStatus.expired.name ||
  //       serviceStatus == ServiceStatus.payment_failed.name) {
  //     color = Colors.red;
  //   }

  //   return Text(
  //     text,
  //     style: TextStyle(
  //       fontSize: 15,
  //       fontWeight: FontWeight.w500,
  //       color: color,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
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
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: UserAvatar(
                        widget.historicalService.chatPartnerAvatarUrl),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.historicalService.chatPartnerUsername,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: geTextByServiceStatus(
                              context,
                              widget.historicalService.status,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${DateFormat("yMMMMd").format(widget.historicalService.appointmentTime.toLocal())} at ${DateFormat.jm().format(widget.historicalService.appointmentTime.toLocal())}',
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
