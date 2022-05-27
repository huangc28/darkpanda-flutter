import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';

class UserServiceGrid extends StatelessWidget {
  const UserServiceGrid({
    Key key,
    this.userService,
    this.onConfirmDelete,
  }) : super(key: key);

  final UserServiceResponse userService;
  final VoidCallback onConfirmDelete;

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
                  userService.serviceName,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: new Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: onConfirmDelete,
                ),
              ],
            ),
            // Text(
            //   userService.price.toString() + 'TWD',
            //   style: TextStyle(color: Colors.white),
            // ),
            SizedBox(height: 2),
            Text(
              userService.duration.toString() + ' 分鐘',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
