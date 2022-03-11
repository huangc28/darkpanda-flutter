import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_model.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/add_user_service_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/load_user_service_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_list.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/components/user_service_sheet.dart';
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

class _UserServiceSelectorListState extends State<UserServiceSelectorList>
    with SingleTickerProviderStateMixin {
  final SlideUpController _slideUpController = SlideUpController();

  /// Animations controllers.
  /// TODO: slide animation should be extract to a mixin or parent widget.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  AuthUser _sender;

  List<UserServiceResponse> _userServices;

  AsyncLoadingStatus _userServiceStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus addUserServiceStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<LoadUserServiceBloc>(context)
        .add(LoadUserService(uuid: _sender.uuid));

    // Initialize slideup panel animation.
    _initSlideUpAnimation();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  _initSlideUpAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          // Start animation at begin
          _slideUpController.toggle();
        } else if (status == AnimationStatus.dismissed) {
          // To hide widget, we need complete animation first
          _slideUpController.toggle();
        }
      });

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));
  }

  _handleTapAddUserService() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: UnfocusPrimary(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: <Widget>[
                      BlocListener<LoadUserServiceBloc, LoadUserServiceState>(
                        listener: (context, state) {
                          if (state.status == AsyncLoadingStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error.message),
                              ),
                            );
                          }

                          if (state.status == AsyncLoadingStatus.done) {
                            _userServices =
                                state.userServiceListResponse.userServiceList;

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
                                      if (_animationController.isDismissed) {
                                        if (service.serviceName == '其他') {
                                          _handleTapAddUserService();
                                        } else {
                                          Navigator.pop<String>(
                                              context, service.serviceName);
                                        }
                                      }
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: UserServiceSelectorGrid(
                                      userService: service,
                                      selectedUserService:
                                          widget.initialUserService,
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
                      BlocListener<AddUserServiceBloc, AddUserServiceState>(
                        listener: (_, state) {
                          if (state.status == AsyncLoadingStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error.message),
                              ),
                            );
                          }

                          if (state.status == AsyncLoadingStatus.done) {
                            BlocProvider.of<LoadUserServiceBloc>(context)
                                .add(LoadUserService(uuid: _sender.uuid));

                            _handleTapAddUserService();
                          }

                          setState(() {
                            addUserServiceStatus = state.status;
                          });
                        },
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              SlideTransition(
                position: _offsetAnimation,
                child: UserServiceSheet(
                  controller: _slideUpController,
                  isLoading: addUserServiceStatus,
                  userServiceList: _userServices,
                  onTapClose: () {
                    _animationController.reverse();
                  },
                  onCreateUserService: (UserServiceModel data) {
                    BlocProvider.of<AddUserServiceBloc>(context).add(
                      AddUserService(
                        name: data.serviceName,
                        description: data.description,
                        price: data.price,
                        duration: data.duration,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
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
    );
  }
}
