import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => onTapAvatar(inquiry.inquirer.uuid),
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  alignment: Alignment.topCenter,
                  child: UserAvatar(inquiry.inquirer.avatarURL),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: _buildInquiryDetailBar(
                      serviceType: inquiry.serviceType,
                      username: inquiry.inquirer.username,
                      budget: inquiry.budget,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 14),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 20,
                        ),
                        onPressed: _handleTapPickup,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTapPickup() {
    onTapPickup(inquiry.uuid);
  }
}
