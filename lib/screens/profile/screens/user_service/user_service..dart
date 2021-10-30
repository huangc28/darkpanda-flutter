import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    _userServices = [
      UserServiceObj(
        name: '家教',
        price: 1000,
        minute: 60,
      ),
      UserServiceObj(
        name: '教書法',
        price: 1500,
        minute: 60,
      ),
      UserServiceObj(
        name: '私人秘書',
        price: 2000,
        minute: 60,
      )
    ];

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
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: UserServiceList(
                        userServices: _userServices,
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
                                      index.toString());
                                  // BlocProvider.of<CancelServiceBloc>(context).add(CancelService(
                                  //     serviceUuid: widget.historicalService.serviceUuid));
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SlideTransition(
                position: _offsetAnimation,
                child: UserSericeSheet(
                  controller: _slideUpController,
                  onTapClose: () {
                    _animationController.reverse();
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
