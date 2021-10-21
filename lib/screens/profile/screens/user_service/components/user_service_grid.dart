import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';

class UserServiceGrid extends StatelessWidget {
  const UserServiceGrid({
    Key key,
    this.userService,
  }) : super(key: key);

  final UserServiceObj userService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  userService.name,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: new Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              userService.price.toString() + 'TWD',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 2),
            Text(
              userService.minute.toString() + ' 分鐘',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
