import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';

typedef ChatroomBuilder = Widget Function(
    BuildContext context, Chatroom chatroom, int index);

class ChatroomList extends StatelessWidget {
  const ChatroomList({
    this.chatroomBuilder,
    this.chatrooms,
    this.onRefresh,
    this.onLoadMore,
  });

  final ChatroomBuilder chatroomBuilder;
  final List<Chatroom> chatrooms;
  final Function onRefresh;
  final Function onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadMoreScrollable(
        onLoadMore: onLoadMore,
        builder: (context, scrollController) => RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: chatrooms.length,
            itemBuilder: (BuildContext context, int idx) =>
                chatroomBuilder(context, chatrooms[idx], idx),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
