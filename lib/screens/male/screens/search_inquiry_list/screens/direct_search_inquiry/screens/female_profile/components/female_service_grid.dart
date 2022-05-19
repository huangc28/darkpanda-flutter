import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';

class FemaleServiceGrid extends StatelessWidget {
  const FemaleServiceGrid({
    Key key,
    this.userService,
    this.serviceLength,
    this.index,
    this.expectServiceType,
  }) : super(key: key);

  final UserServiceResponse userService;
  final int serviceLength;
  final int index;
  final String expectServiceType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
      decoration: userService.serviceName == expectServiceType
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
                userService.serviceName,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              // Text(
              //   userService.price.toString() + 'TWD',
              //   style: TextStyle(color: Colors.white),
              // ),
              Text(
                userService.duration.toString() + ' 分鐘',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              userService.serviceName == expectServiceType
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
