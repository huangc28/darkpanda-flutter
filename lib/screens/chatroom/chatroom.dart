import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';

import 'components/chat_bubble.dart';
import 'components/send_message_bar.dart';
import 'components/chatroom_window.dart';
import 'components/service_settings_sheet.dart';

import './models/service_settings.dart';

part 'chatroom_screen_arguments.dart';

// @TOODs:
//   - Scroll list view to bottom when new message is appended to list - [ok].
//   - Clear text field after new message is emitted successfully - [ok].
//   - Load more historical messages - [ok].
//   - Display error when fetching historical message / send message failed - [ok].
//   - Display loading icon when fetching historical messages.
//   - Make a service booking panel. Service provider should be able to tailor the service detail.
//   - Remove historical messages and current messages when leaving the chatroom - [ok].
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

  @override
  void initState() {
    super.initState();

    BlocProvider.of<CurrentChatroomBloc>(context).add(
      InitCurrentChatroom(channelUUID: widget.args.channelUUID),
    );

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
    final sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    return BlocConsumer<CurrentChatroomBloc, CurrentChatroomState>(
      listener: (context, state) {
        // if there is an error fetching
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
              IconButton(
                icon: Icon(Icons.assignment),
                iconSize: 25,
                color: Colors.white,
                onPressed: handleTapServiceSetting,
              ),
            ],
          ),
          body: Column(
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
                        return ChatroomWindow(
                            scrollController: scrollController,
                            historicalMessages: state.historicalMessages,
                            currentMessages: state.currentMessages,
                            builder: (BuildContext context, Message message) {
                              return ChatBubble(
                                // isMe: message.to == senderUUID,
                                isMe: true,
                                message: message,
                              );
                            });
                      })),
              BlocListener<SendMessageBloc, SendMessageState>(
                listener: (context, state) {
                  if (state.status == SendMessageStatus.loaded) {
                    _editMessageController.clear();
                  }
                },
                child: SendMessageBar(
                  editMessageController: _editMessageController,
                  onSend: () {
                    // Emit message if the value of _message is not empty
                    if (_message.isEmpty) {
                      return;
                    }

                    BlocProvider.of<SendMessageBloc>(context).add(
                      SendMessageEvent(
                        content: _message,
                        channelUUID: widget.args.channelUUID,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  handleTapServiceSetting() async {
    final ServiceSettings serviceSetting = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ServiceSettingsSheet(),
        fullscreenDialog: true,
      ),
    );

    // Sends a service detail message to chatroom.
    print('DEBUG spot serviceSetting $serviceSetting');
  }
}
