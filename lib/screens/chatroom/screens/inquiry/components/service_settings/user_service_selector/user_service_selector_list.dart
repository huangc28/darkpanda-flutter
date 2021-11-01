import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';
import 'package:flutter/material.dart';

import 'user_service_selector_grid.dart';

class UserServiceSelectorList extends StatelessWidget {
  const UserServiceSelectorList({
    Key key,
    this.initialUserService,
    this.onSelected,
    this.userServices,
  }) : super(key: key);

  final String initialUserService;
  final ValueChanged<String> onSelected;
  final List<UserServiceObj> userServices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('選擇服務'),
        centerTitle: true,
        leading: IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: UserServiceList(
            userServices: userServices,
            userServiceBuilder: (context, service, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop<String>(context, service.name);
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: UserServiceSelectorGrid(
                  userService: service,
                  selectedUserService: initialUserService,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
