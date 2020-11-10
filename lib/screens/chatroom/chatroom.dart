import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';

import './chat_bubble.dart';
import './send_message_bar.dart';
import './chatroom_window.dart';

part 'chatroom_screen_arguments.dart';

// @TOODs:
//   - Scroll list view to bottom when new message is appended to list - [ok].
//   - Clear text field after new message is emitted successfully - [ok].
//   - Load more historical messages - [].
//   - Display error when fetch historical message / send message failed.
//   - Make a service booking panel. Service provider should be able to tailor the service detail.
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
  void dispose() {
    _editMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sender = BlocProvider.of<AuthUserBloc>(context).state.user;

    return BlocBuilder<CurrentChatroomBloc, CurrentChatroomState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chatroom'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ChatroomWindow(
                    historicalMessages: state.historicalMessages,
                    currentMessages: state.currentMessages,
                    builder: (BuildContext context, Message message) {
                      return ChatBubble(
                        // isMe: message.to == senderUUID,
                        isMe: true,
                        message: message,
                      );
                    }),
              ),
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
}
