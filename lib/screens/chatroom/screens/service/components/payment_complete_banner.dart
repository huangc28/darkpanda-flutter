import 'package:darkpanda_flutter/util/time_remaining_since_date.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/models/service_details.dart';

class PaymentCompleteBanner extends StatelessWidget {
  const PaymentCompleteBanner({
    Key key,
    this.inquirerProfile,
    this.serviceDetails,
  }) : super(key: key);

  final UserProfile inquirerProfile;
  final ServiceDetails serviceDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(31, 30, 56, 1),
      child: Column(
        children: <Widget>[
          _tradeInfo(),
        ],
      ),
    );
  }

  Widget _tradeInfo() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: UserAvatar(inquirerProfile.avatarUrl != null
                ? inquirerProfile.avatarUrl
                : ''),
            width: 38,
            height: 38,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '服務已付款',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '服務將在' +
                          DateTimeUtil.timeAgoSinceDate(
                              serviceDetails.appointmentTime.toLocal()),
                      // '服務將在 ${DateFormat("hh:mm").format(serviceDetails.endTime.toLocal())} 結束',
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
        ],
      ),
    );
  }
}
