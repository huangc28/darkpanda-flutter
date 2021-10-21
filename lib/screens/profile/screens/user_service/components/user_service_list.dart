import 'package:flutter/material.dart';

typedef UserServiceBuilder = Widget Function(
    BuildContext context, UserServiceObj chatroom, int index);

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
  }) : super(key: key);

  final UserServiceBuilder userServiceBuilder;
  final List<UserServiceObj> userServices;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
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
