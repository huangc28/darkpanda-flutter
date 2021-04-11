import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/bloc/notify_service_confirmed_bloc.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';

import 'components/chat_bubble.dart';
import 'components/confirmed_service_bubble.dart';
import 'components/service_detail_bubble.dart';
import 'components/send_message_bar.dart';
import 'components/chatroom_window.dart';
import 'components/service_settings_sheet.dart';

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

class _ChatroomState extends State<Chatroom> {
  final _editMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _message;
  AuthUser _sender;
  bool serviceConfirmed = false;

  @override
  void initState() {
    _sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(channelUUID: widget.args.channelUUID),
    );

    super.initState();

    // Fetch inquiry related service if exists
    // BlocProvider.of<CurrentServiceBloc>(context).add(
    //   GetCurrentService(
    //     inquiryUUID: widget.args.inquiryUUID,
    //   ),
    // );

    _editMessageController.addListener(_handleEditMessage);
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
  void dispose() {
    _editMessageController.dispose();
    super.dispose();
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
            title: Text('Chatroom'),
            actions: [
              BlocBuilder<CurrentServiceBloc, GetServiceState>(
                  builder: (context, state) {
                if (state.status == GetServiceStatus.loadFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == GetServiceStatus.loaded) {
                  return IconButton(
                    icon: Icon(Icons.assignment),
                    iconSize: 25,
                    color: Colors.white,
                    onPressed: () => serviceConfirmed
                        ? null
                        : _handleTapServiceSetting(state.serviceSettings),
                  );
                }

                return Container(
                  width: 0,
                  height: 0,
                );
              }),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: LoadMoreScrollable(
                      scrollController: _scrollController,
                      onLoadMore: () {
                        BlocProvider.of<CurrentChatroomBloc>(context).add(
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
                          child: ChatroomWindow(
                            scrollController: scrollController,
                            historicalMessages: state.historicalMessages,
                            currentMessages: state.currentMessages,
                            builder: (BuildContext context, message) {
                              // Render different chat bubble based on message type.
                              if (message is ServiceDetailMessage) {
                                return ServiceDetailBubble(
                                  isMe: _sender.uuid == message.from,
                                  message: message,
                                  onTapMessage: _handleTapServiceSettingMessage,
                                );
                              } else if (message is ServiceConfirmedMessage) {
                                return ConfirmedServiceBubble(
                                  isMe: _sender.uuid == message.from,
                                  message: message,
                                );
                              } else {
                                return ChatBubble(
                                  isMe: _sender.uuid == message.from,
                                  message: message,
                                );
                              }
                            },
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
                        print('DEBUG trigger on send ${_message}');
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
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _handleTapServiceSettingMessage(ServiceDetailMessage message) async {
    final ServiceSettings serviceSettings = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ServiceSettingsSheet(
          serviceSettings: ServiceSettings.fromServiceDetailMessage(message),
        ),
        fullscreenDialog: true,
      ),
    );

    if (serviceSettings == null) {
      return null;
    }

    BlocProvider.of<SendMessageBloc>(context).add(
      SendServiceDetailConfirmMessage(
        channelUUID: widget.args.channelUUID,
        serviceSettings: serviceSettings,
        inquiryUUID: widget.args.inquiryUUID,
      ),
    );
  }

  _handleTapServiceSetting(ServiceSettings ss) async {
    final ServiceSettings updatedss = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ServiceSettingsSheet(
          serviceSettings: ss,
        ),
        fullscreenDialog: true,
      ),
    );

    // If serviceSettings is null, do nothing
    if (updatedss == null) {
      return;
    }

    // Sends a service detail message to chatroom.
    BlocProvider.of<SendMessageBloc>(context).add(
      SendServiceDetailConfirmMessage(
        inquiryUUID: widget.args.inquiryUUID,
        channelUUID: widget.args.channelUUID,
        serviceSettings: updatedss,
      ),
    );
  }
}
