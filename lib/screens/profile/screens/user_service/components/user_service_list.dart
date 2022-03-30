import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:flutter/material.dart';

typedef UserServiceBuilder = Widget Function(
    BuildContext context, UserServiceResponse chatroom, int index);

class UserServiceObj {
  final String name;
  final int price;
  final int minute;

  UserServiceObj({
    this.name,
    this.price,
    this.minute,
  });
}

class UserServiceList extends StatelessWidget {
  const UserServiceList({
    Key key,
    this.userServiceBuilder,
    this.userServices,
    this.scrollPhysics,
  }) : super(key: key);

  final UserServiceBuilder userServiceBuilder;
  final List<UserServiceResponse> userServices;
  final ScrollPhysics scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return userServices.length == 0
        ? Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '尚未建立服務',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: ListView.separated(
              shrinkWrap: true,
              physics: scrollPhysics,
              itemCount: userServices.length,
              itemBuilder: (BuildContext context, int idx) =>
                  userServiceBuilder(context, userServices[idx], idx),
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[600],
                );
              },
            ),
          );
  }
}
