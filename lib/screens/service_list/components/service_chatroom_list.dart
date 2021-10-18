import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';

import '../models/incoming_service.dart';

typedef ChatroomBuilder = Widget Function(
    BuildContext context, IncomingService chatroom, int index);

class ServiceChatroomList extends StatelessWidget {
  const ServiceChatroomList({
    this.chatroomBuilder,
    this.chatrooms,
    this.onRefresh,
    this.onLoadMore,
  });

  final ChatroomBuilder chatroomBuilder;
  final List<IncomingService> chatrooms;
  final Function onRefresh;
  final Function onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 26,
      ),
      child: LoadMoreScrollable(
        onLoadMore: onLoadMore,
        builder: (context, scrollController) => RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            height: SizeConfig.screenHeight,
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
      ),
    );
  }
}
