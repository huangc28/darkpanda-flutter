import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/bloc/notify_service_confirmed_bloc.dart';
import 'package:darkpanda_flutter/bloc/get_inquiry_bloc.dart';

/// @TODO: move these message models to a folder
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';

import 'components/chat_bubble.dart';
import 'components/confirmed_service_bubble.dart';
import 'components/service_detail_bubble.dart';
import 'components/update_inquiry_bubble.dart';

import 'components/send_message_bar.dart';
import 'components/chatroom_window.dart';
import 'components/service_settings/service_settings.dart';

import '../../models/service_settings.dart';

part 'screen_arguments/chatroom_screen_arguments.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    this.args,
  });

  final ChatroomScreenArguments args;

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom>
    with SingleTickerProviderStateMixin {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SlideUpController _slideUpController = SlideUpController();

  String _message;
  AuthUser _sender;
  bool serviceConfirmed = false;

  /// Animations controllers.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  /// [ServiceSettings] model to be passed down to service settings sheet.
  ServiceSettings _serviceSettings;

  @override
  void initState() {
    super.initState();

    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;
    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(channelUUID: widget.args.channelUUID),
    );

    // Fetch inquiry related inquiry if exists
    BlocProvider.of<GetInquiryBloc>(context).add(
      GetInquiry(inquiryUuid: widget.args.inquiryUUID),
    );

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
    BlocProvider.of<CurrentChatroomBloc>(context).add(
      LeaveCurrentChatroom(),
    );

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentChatroomBloc, CurrentChatroomState>(
      listener: (context, state) {
        if (state.status == FetchHistoricalMessageStatus.loadFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _sender.username,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: LoadMoreScrollable(
                              scrollController: _scrollController,
                              onLoadMore: () {
                                BlocProvider.of<CurrentChatroomBloc>(context)
                                    .add(
                                  FetchMoreHistoricalMessages(
                                    channelUUID: widget.args.channelUUID,
                                  ),
                                );
                              },
                              builder: (context, scrollController) {
                                return BlocListener<NotifyServiceConfirmedBloc,
                                    NotifyServiceConfirmedState>(
                                  listener: (context, state) {
                                    if (state.confirmed) {
                                      // Lock the message sending button
                                      // Lock the detail setting panel
                                      setState(() {
                                        serviceConfirmed = true;
                                      });
                                    }
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!_animationController.isDismissed) {
                                        _animationController.reverse();
                                      }
                                    },
                                    child: ChatroomWindow(
                                      scrollController: scrollController,
                                      historicalMessages:
                                          state.historicalMessages,
                                      currentMessages: state.currentMessages,
                                      builder: (BuildContext context, message) {
                                        // Render different chat bubble based on message type.
                                        if (message
                                            is ServiceConfirmedMessage) {
                                          return ConfirmedServiceBubble(
                                            isMe: _sender.uuid == message.from,
                                            message: message,
                                          );
                                        } else if (message
                                            is UpdateInquiryMessage) {
                                          return UpdateInquiryBubble(
                                            isMe: _sender.uuid == message.from,
                                            message: message,
                                            onTapMessage: (message) {
                                              // Slideup inquiry pannel.
                                              _animationController.forward();
                                            },
                                          );
                                        } else {
                                          return ChatBubble(
                                            isMe: _sender.uuid == message.from,
                                            message: message,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          BlocListener<SendMessageBloc, SendMessageState>(
                            listener: (context, state) {
                              if (state.status == SendMessageStatus.loaded) {
                                _editMessageController.clear();
                              }
                            },
                            child: SendMessageBar(
                              disable: serviceConfirmed,
                              editMessageController: _editMessageController,
                              onSend: () {
                                // Emit message if the value of _message is not empty
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
                              onEditInquiry: _handleTapEditInquiry,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Listen the loading status of `GetInquiryBloc`. If status is loading,
                  // display spinner on service settings sheet.
                  SlideTransition(
                    position: _offsetAnimation,
                    child: BlocListener<GetInquiryBloc, GetInquiryState>(
                      listener: (_, state) {
                        if (state.status == AsyncLoadingStatus.done) {
                          print(
                              'DEBUG done loading iq ${state.serviceSettings}');
                          setState(() {
                            _serviceSettings = state.serviceSettings;
                          });
                        }
                      },
                      child: ServiceSettingsSheet(
                        serviceSettings: _serviceSettings,
                        controller: _slideUpController,
                        onTapClose: () {
                          _animationController.reverse();
                        },
                        onUpdateInquiry: (ServiceSettings data) {
                          print('DEBUG onUpdateInquiry data ${data}');

                          setState(() {
                            _serviceSettings = data;
                          });

                          /// Send inquiry settings message when done editing inquiry.
                          BlocProvider.of<SendMessageBloc>(context).add(
                            SendUpdateInquiryMessage(
                              inquiryUUID: widget.args.inquiryUUID,
                              channelUUID: widget.args.channelUUID,
                              serviceSettings: data,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _handleTapEditInquiry() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // _handleTapServiceSettingMessage(ServiceDetailMessage message) async {
  //   final serviceSettings = await _showServiceDetailModal(
  //       ServiceSettings.fromServiceDetailMessage(message));

  //   if (serviceSettings == null) {
  //     return null;
  //   }

  //   BlocProvider.of<SendMessageBloc>(context).add(
  //     SendServiceDetailConfirmMessage(
  //       channelUUID: widget.args.channelUUID,
  //       serviceSettings: serviceSettings,
  //       inquiryUUID: widget.args.inquiryUUID,
  //     ),
  //   );
  // }

  // Future<ServiceSettings> _showServiceDetailModal(
  //     [ServiceSettings settings]) async {
  //   final ServiceSettings serviceSettings = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => ServiceSettingsSheet(
  //         serviceSettings: settings,
  //       ),
  //       fullscreenDialog: true,
  //     ),
  //   );

  //   return serviceSettings;
  // }

  // _handleTapServiceSetting(ServiceSettings ss) async {
  //   final ServiceSettings updatedss = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => ServiceSettingsSheet(
  //         serviceSettings: ss,
  //       ),
  //       fullscreenDialog: true,
  //     ),
  //   );

  //   // If serviceSettings is null, do nothing
  //   if (updatedss == null) {
  //     return;
  //   }

  //   // Sends a service detail message to chatroom.
  //   BlocProvider.of<SendMessageBloc>(context).add(
  //     SendServiceDetailConfirmMessage(
  //       inquiryUUID: widget.args.inquiryUUID,
  //       channelUUID: widget.args.channelUUID,
  //       serviceSettings: updatedss,
  //     ),
  //   );
  // }
}
