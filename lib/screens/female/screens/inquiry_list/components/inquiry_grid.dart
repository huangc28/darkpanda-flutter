import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/bullet.dart';

import '../../../models/inquiry.dart';

class InquiryGrid extends StatelessWidget {
  const InquiryGrid({
    Key key,
    @required this.onTapAvatar,
    @required this.onTapPickup,
    this.inquiry,
  }) : super(key: key);

  final Inquiry inquiry;
  final ValueChanged<String> onTapAvatar;
  final ValueChanged<String> onTapPickup;

  Widget _buildInquiryDetailBar(
          {String serviceType, String username, double budget}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 6),
          Text('$serviceType - \$$budget'),
        ],
      );

  Widget _buildInquiryInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inquiry details.
        Container(
          padding: EdgeInsets.only(
            left: 31,
            right: 25,
            bottom: 7,
          ),
          child: Column(
            children: [
              // Inquirer avatar.
              SizedBox(
                height: 59,
                width: 59,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/59',
                  ),
                ),
              ),
              SizedBox(height: 6),

              // Inquirer name
              Text(
                'Brat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bullet(
              '預算: 0 ~ 112 DP',
              style: TextStyle(
                height: 1.3,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Bullet(
              '項目: 看電影',
              style: TextStyle(
                color: Colors.white,
                height: 1.3,
                fontSize: 16,
              ),
            ),
            Bullet(
              '時間: 12.18 at 00:20 AM',
              style: TextStyle(
                color: Colors.white,
                height: 1.3,
                fontSize: 16,
              ),
            ),
            Bullet(
              '時長: 12.18 at 00:20 AM',
              style: TextStyle(
                color: Colors.white,
                height: 1.3,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(106, 109, 137, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 14,
          left: 31,
        ),
        margin: const EdgeInsetsDirectional.only(
          start: 0.5,
          end: 0.5,
          top: 1,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6.0),
            topRight: const Radius.circular(6.0),
          ),
        ),
        child: Row(
          children: [
            // Hide button

            // Check profile button

            // Chat now button
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 9,
        bottom: 14,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Color.fromRGBO(31, 30, 56, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInquiryInfo(),
          _buildActionBar(),
        ],
      ),
    );

    // child: Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Expanded(
    //         flex: 1,
    //         child: GestureDetector(
    //           onTap: () => onTapAvatar(inquiry.inquirer.uuid),
    //           child: Container(
    //             padding: const EdgeInsets.only(left: 12),
    //             alignment: Alignment.topCenter,
    //             child: UserAvatar(inquiry.inquirer.avatarURL),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         width: 8,
    //       ),
    //       Expanded(
    //         flex: 3,
    //         child: Row(
    //           children: [
    //             Container(
    //               alignment: Alignment.topLeft,
    //               child: _buildInquiryDetailBar(
    //                 serviceType: inquiry.serviceType,
    //                 username: inquiry.inquirer.username,
    //                 budget: inquiry.budget,
    //               ),
    //             ),
    //             Expanded(
    //               child: Container(
    //                 padding: const EdgeInsets.only(right: 14),
    //                 alignment: Alignment.topRight,
    //                 child: IconButton(
    //                   icon: Icon(
    //                     Icons.chevron_right,
    //                     size: 20,
    //                   ),
    //                   onPressed: _handleTapPickup,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  }

  void _handleTapPickup() {
    onTapPickup(inquiry.uuid);
  }
}
