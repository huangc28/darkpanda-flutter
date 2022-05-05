import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';

class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    Key key,
    this.avatarUrl,
    this.username,
  }) : super(key: key);

  Widget _buildStatusBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '服務已成立! 請繼續交談',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }

  final String avatarUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print('on tap banner');
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        height: 98,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar image.
            UserAvatar(avatarUrl),
            SizedBox(width: 12),

            _buildStatusBar(),
          ],
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
        ),
      ),
    );
  }
}
