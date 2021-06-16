import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/components/qr_scanner.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_qrcode_apis.dart';

import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';

import '../../components/chat_bubble.dart';
import '../../components/confirmed_service_bubble.dart';
import '../../components/update_inquiry_bubble.dart';
import 'bloc/current_service_chatroom_bloc.dart';
import 'bloc/service_qrcode_bloc.dart';
import 'components/send_message_bar.dart';
import '../../components/chatroom_window.dart';

import '../../../../models/service_settings.dart';
import 'screen_arguments/qrscanner_screen_arguments.dart';

part 'screen_arguments/service_chatroom_screen_arguments.dart';
part 'components/notification_banner.dart';
part 'components/unpaid_info.dart';

class ServiceChatroom extends StatefulWidget {
  const ServiceChatroom({
    this.args,
  });

  final ServiceChatroomScreenArguments args;

  @override
  _ServiceChatroomState createState() => _ServiceChatroomState();
}

class _ServiceChatroomState extends State<ServiceChatroom>
    with SingleTickerProviderStateMixin {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SlideUpController _slideUpController = SlideUpController();

  String _message;
  AuthUser _sender;

  /// If male user confirmed the service, toggle this state to be true to prevent
  /// further editing of the service detail.
  bool _serviceConfirmed = false;

  /// Lock the message bar functionalities if we are still initialzing chatroom.
  /// until chatroom is done initializing.
  bool _doneInitChatroom = false;

  /// Information of the inquirer that the current user is talking with.
  UserProfile _inquirerProfile = UserProfile();

  /// Animations controllers.
  /// TODO: slide animation should be extract to a mixin or parent widget.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  /// [ServiceSettings] model to be passed down to service settings sheet.
  ServiceSettings _serviceSettings;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentServiceChatroomBloc>(context).add(
      InitCurrentServiceChatroom(
          channelUUID: widget.args.channelUUID,
          inquirerUUID: widget.args.counterPartUUID),
    );

    // Fetch inquiry related inquiry if exists.
    // BlocProvider.of<GetInquiryBloc>(context).add(
    //   GetInquiry(inquiryUuid: widget.args.inquiryUUID),
    // );

    _editMessageController.addListener(_handleEditMessage);

    // Initialize slideup panel animation.
    _initSlideUpAnimation();
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

  @override
  void dispose() {
    super.dispose();

    _editMessageController.dispose();
    _animationController.dispose();
  }

  _handleEditMessage() {
    setState(() {
      _message = _editMessageController.value.text;
    });
  }

  @override
  void deactivate() {
    BlocProvider.of<CurrentServiceChatroomBloc>(context).add(
      LeaveCurrentServiceChatroom(),
    );

    super.deactivate();
  }

  Widget _buildMessageBar() {
    return BlocListener<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          _editMessageController.clear();
        }
      },
      child: SendMessageBar(
        disable: _serviceConfirmed,
        editMessageController: _editMessageController,
        onSend: () {
          if (_message.isEmpty) {
            return;
          }

          BlocProvider.of<SendMessageBloc>(context).add(
            SendTextMessage(
              content: _message,
              channelUUID: widget.args.channelUUID,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CurrentServiceChatroomBloc,
            CurrentServiceChatroomState>(
          builder: (context, state) {
            return Text(
              state.status == AsyncLoadingStatus.done
                  ? state.userProfile.username
                  : '',
              style: TextStyle(
                fontSize: 18,
              ),
            );
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => ServiceQrCodeBloc(
                          serviceQrCodeApis: ServiceQrCodeAPIs(),
                        ),
                      ),
                    ],
                    child: QrScanner(
                      args: QrscannerScreenArguments(
                        serviceUuid: widget.args.serviceUUID,
                      ),
                    ),
                  ),
                ));
              },
              child: Icon(Icons.qr_code_scanner),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                child: Column(
                  children: [
                    if (_sender.gender == Gender.male)
                      UnpaidInfo(
                        inquirerProfile: _inquirerProfile,
                      ),
                    Expanded(
                      child: LoadMoreScrollable(
                        scrollController: _scrollController,
                        onLoadMore: () {
                          BlocProvider.of<CurrentServiceChatroomBloc>(context)
                              .add(
                            FetchMoreHistoricalMessages(
                              channelUUID: widget.args.channelUUID,
                            ),
                          );
                        },
                        builder: (context, scrollController) {
                          return Stack(
                            children: [
                              BlocListener<ServiceConfirmNotifierBloc,
                                  ServiceConfirmNotifierState>(
                                listener: (context, state) {
                                  setState(() {
                                    // If male user confirmed the service, toggle the _serviceConfirmed to be true.
                                    // so that the female user can not edit the service anymore.
                                    _serviceConfirmed = true;
                                  });
                                },
                                child: BlocConsumer<CurrentServiceChatroomBloc,
                                    CurrentServiceChatroomState>(
                                  listener: (context, state) {
                                    if (state.status ==
                                        AsyncLoadingStatus.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(state.error.message),
                                        ),
                                      );
                                    }

                                    // Enable message bar once done initializing.
                                    if (state.status ==
                                        AsyncLoadingStatus.done) {
                                      setState(() {
                                        _doneInitChatroom = true;

                                        _inquirerProfile = state.userProfile;
                                      });
                                    }
                                  },
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Dismiss inquiry detail pannel.
                                        if (!_animationController.isDismissed) {
                                          _animationController.reverse();
                                        }

                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);

                                        // Dismiss keyboard when user clicks on chat window.
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      },
                                      child: ChatroomWindow(
                                        scrollController: scrollController,
                                        historicalMessages:
                                            state.historicalMessages,
                                        currentMessages: state.currentMessages,
                                        builder:
                                            (BuildContext context, message) {
                                          // Render different chat bubble based on message type.
                                          if (message
                                              is ServiceConfirmedMessage) {
                                            return ConfirmedServiceBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          } else if (message
                                              is UpdateInquiryMessage) {
                                            return UpdateInquiryBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                              onTapMessage: (message) {
                                                // Slideup inquiry pannel.
                                                _animationController.forward();
                                              },
                                            );
                                          } else {
                                            return ChatBubble(
                                              isMe:
                                                  _sender.uuid == message.from,
                                              message: message,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // When we receive service confirmed message, we will
                              // display this top notification banner.
                              _serviceConfirmed
                                  ? NotificationBanner(
                                      avatarUrl: _inquirerProfile.avatarUrl,
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                    ),
                    _doneInitChatroom
                        ? _buildMessageBar()
                        : Center(
                            child: Container(
                              height: 50,
                              child: LoadingIcon(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
