part of '../chatroom.dart';

class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    Key key,
    this.avatarUrl,
    this.goToServiceChatroom,
  }) : super(key: key);

  final String avatarUrl;
  final VoidCallback goToServiceChatroom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToServiceChatroom,
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        height: 98,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Avatar image.
            UserAvatar(avatarUrl),
            SizedBox(width: 12),

            _buildStatusBar(),

            InkWell(
              onTap: goToServiceChatroom,
              child: Icon(
                Icons.navigate_next,
                size: 22,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '服務已成立! 請至管理繼續交談',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
