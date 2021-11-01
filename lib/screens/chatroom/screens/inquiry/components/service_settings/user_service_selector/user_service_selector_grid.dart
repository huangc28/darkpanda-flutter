import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';
import 'package:flutter/material.dart';

class UserServiceSelectorGrid extends StatelessWidget {
  const UserServiceSelectorGrid({
    Key key,
    this.userService,
    this.selectedUserService,
  }) : super(key: key);

  final UserServiceObj userService;
  final String selectedUserService;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      decoration: userService.name == selectedUserService
          ? BoxDecoration(
              color: Color.fromRGBO(190, 172, 255, 0.3),
            )
          : BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userService.name,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              userService.name == selectedUserService
                  ? Text(
                      '已選擇',
                      style: TextStyle(color: Colors.white),
                    )
                  : Container(),
              SizedBox(width: 2),
              Container(
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
