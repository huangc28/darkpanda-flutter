import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_model.dart';
import 'package:darkpanda_flutter/screens/profile/models/user_service_response.dart';
import 'package:darkpanda_flutter/screens/profile/screens/user_service/bloc/remove_user_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/add_user_service_bloc.dart';
import 'bloc/load_user_service_bloc.dart';
import 'components/delete_user_service_confirmation_dialog.dart';
import 'components/user_service_grid.dart';
import 'components/user_service_list.dart';
import 'components/user_service_sheet.dart';

class UserService extends StatefulWidget {
  const UserService({Key key}) : super(key: key);

  @override
  _UserServiceState createState() => _UserServiceState();
}

class _UserServiceState extends State<UserService>
    with SingleTickerProviderStateMixin {
  final SlideUpController _slideUpController = SlideUpController();

  /// Animations controllers.
  /// TODO: slide animation should be extract to a mixin or parent widget.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  List<UserServiceObj> _userServices;

  AuthUser _sender;
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

  void _removeUserService(int serviceOptionId) {
    BlocProvider.of<RemoveUserServiceBloc>(context)
        .add(RemoveUserService(serviceOptionId: serviceOptionId));
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _serviceList(),
                  ],
                ),
              ),
              BlocListener<RemoveUserServiceBloc, RemoveUserServiceState>(
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
                  }
                },
                child: Container(),
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
              SlideTransition(
                position: _offsetAnimation,
                child: UserServiceSheet(
                  controller: _slideUpController,
                  isLoading: addUserServiceStatus,
                  onTapClose: () {
                    _animationController.reverse();
                  },
                  onCreateUserService: (UserServiceModel data) {
                    BlocProvider.of<AddUserServiceBloc>(context).add(
                      AddUserService(
                        name: data.serviceName,
                        description: data.description,
                        price: data.price,
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

  Widget _serviceList() {
    return BlocConsumer<LoadUserServiceBloc, LoadUserServiceState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );

          return null;
        }
      },
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.loading ||
            state.status == AsyncLoadingStatus.initial) {
          return Row(
            children: [
              LoadingScreen(),
            ],
          );
        }

        return Expanded(
          child: UserServiceList(
            userServices: state.userServiceListResponse.userServiceList,
            userServiceBuilder: (context, service, index) {
              return UserServiceGrid(
                userService: service,
                onConfirmDelete: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteUserServiceConfirmationDialog();
                    },
                  ).then((value) {
                    if (value) {
                      print('Delete user service: ' +
                          service.userOptionId.toString());

                      _removeUserService(service.userOptionId);
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('我的服務'),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Color.fromRGBO(106, 109, 137, 1),
      ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: _handleTapAddUserService,
        ),
      ],
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
    );
  }
}
