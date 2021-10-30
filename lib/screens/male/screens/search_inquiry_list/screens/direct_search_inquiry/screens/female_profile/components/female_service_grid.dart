import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';

class FemaleServiceGrid extends StatelessWidget {
  const FemaleServiceGrid({
    Key key,
    this.userService,
    this.serviceLength,
    this.index,
  }) : super(key: key);

  final UserServiceObj userService;
  final int serviceLength;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
      decoration: userService.name == '教書法'
          ? BoxDecoration(
              color: Color.fromRGBO(190, 172, 255, 0.3),
            )
          : BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
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
              SizedBox(height: 4),
              // Hide price if service is last
              serviceLength - 1 == index
                  ? Container()
                  : Text(
                      userService.price.toString() + 'TWD',
                      style: TextStyle(color: Colors.white),
                    ),
              // Hide duration if service is last
              serviceLength - 1 == index
                  ? Container()
                  : Text(
                      userService.minute.toString() + ' 分鐘',
                      style: TextStyle(color: Colors.white),
                    ),
            ],
          ),
          Row(
            children: <Widget>[
              userService.name == '教書法'
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
