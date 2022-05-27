import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:flutter/material.dart';

class UserServiceSelectorGrid extends StatelessWidget {
  const UserServiceSelectorGrid({
    Key key,
    this.userService,
    this.selectedUserService,
    this.userServiceStatus,
  }) : super(key: key);

  final UserServiceResponse userService;
  final String selectedUserService;
  final AsyncLoadingStatus userServiceStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      decoration: userService.serviceName == selectedUserService
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
                  userService.serviceName,
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
              userService.serviceName == selectedUserService
                  ? Text(
                      '已選擇',
                      style: TextStyle(color: Colors.white),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
