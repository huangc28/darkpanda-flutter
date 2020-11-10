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
//   - scroll list view to bottom when new message is appended to list.
//   - clear text field after new message is emitted successfully.
//   - load more historical messages.
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
  final _chatWindowScrollController = ScrollController();

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
    _chatWindowScrollController.dispose();
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
              SendMessageBar(
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
                  // Send chat message
                  // print('DEBUG send # 1 ${_message}');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
