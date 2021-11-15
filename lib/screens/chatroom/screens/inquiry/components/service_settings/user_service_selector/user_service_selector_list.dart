import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/load_user_service_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_service_selector_grid.dart';

class UserServiceSelectorList extends StatefulWidget {
  const UserServiceSelectorList({
    Key key,
    this.initialUserService,
    this.onSelected,
  }) : super(key: key);

  final String initialUserService;
  final ValueChanged<String> onSelected;

  @override
  _UserServiceSelectorListState createState() =>
      _UserServiceSelectorListState();
}

class _UserServiceSelectorListState extends State<UserServiceSelectorList> {
  AuthUser _sender;

  List<UserServiceResponse> _userServices;

  AsyncLoadingStatus _userServiceStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<LoadUserServiceBloc>(context)
        .add(LoadUserService(uuid: _sender.uuid));
  }

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
          child: BlocListener<LoadUserServiceBloc, LoadUserServiceState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                  ),
                );
              }

              if (state.status == AsyncLoadingStatus.done) {
                _userServices = state.userServiceListResponse.userServiceList;

                // Insert into last index in the Array
                _userServices.insert(
                  _userServices.length,
                  UserServiceResponse(serviceName: '其他'),
                );
              }

              setState(() {
                _userServiceStatus = state.status;
              });
            },
            child: _userServiceStatus == AsyncLoadingStatus.done
                ? UserServiceList(
                    userServices: _userServices,
                    userServiceBuilder: (context, service, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop<String>(context, service.serviceName);
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: UserServiceSelectorGrid(
                          userService: service,
                          selectedUserService: widget.initialUserService,
                          userServiceStatus: _userServiceStatus,
                        ),
                      );
                    },
                  )
                : Row(
                    children: [
                      LoadingScreen(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
