import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/message.dart';

typedef BubbleBuilder = Widget Function(BuildContext, Message);

class ChatroomWindow extends StatefulWidget {
  const ChatroomWindow({
    this.scrollController,
    this.historicalMessages,
    this.currentMessages,
    this.builder,
    this.isSendingImage = false,
  });

  final List<Message> historicalMessages;
  final List<Message> currentMessages;
  final BubbleBuilder builder;
  final ScrollController scrollController;
  final bool isSendingImage;

  @override
  _ChatroomWindowState createState() => _ChatroomWindowState();
}

class _ChatroomWindowState extends State<ChatroomWindow> {
  ScrollController _chatWindowScrollController;

  @override
  void initState() {
    super.initState();

    _chatWindowScrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void didUpdateWidget(ChatroomWindow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentMessages.length != oldWidget.currentMessages.length) {
      _scrollWindowToBottom();
    }
  }

  void _scrollWindowToBottom() {
    _chatWindowScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = List<Message>.from(widget.currentMessages)
      ..addAll(widget.historicalMessages);

    return Scrollbar(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                reverse: true,
                controller: _chatWindowScrollController,
                padding: EdgeInsets.all(20),
                itemCount: messages.length,
                itemBuilder: (context, int index) =>
                    widget.builder(context, messages[index])),
          ),
          widget.isSendingImage
              ? Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20, bottom: 10),
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
      isAlwaysShown: true,
      controller: _chatWindowScrollController,
    );
  }
}
