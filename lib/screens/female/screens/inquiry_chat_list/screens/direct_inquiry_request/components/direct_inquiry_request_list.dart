import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/models/direct_inquiry_requests.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

typedef DirectInquiryRequestItemBuilder = Widget Function(
    BuildContext context, DirectInquiryRequests inquiry, int index);

class DirectInquiryRequestList extends StatelessWidget {
  const DirectInquiryRequestList({
    Key key,
    this.onRefresh,
    this.onLoadMore,
    this.inquiries,
    this.inquiryItemBuilder,
  }) : super(key: key);

  final Function onRefresh;

  final Function onLoadMore;

  final List<DirectInquiryRequests> inquiries;

  final DirectInquiryRequestItemBuilder inquiryItemBuilder;

  @override
  Widget build(BuildContext context) {
    return LoadMoreScrollable(
      onLoadMore: onLoadMore,
      builder: (context, scrollController) => RefreshIndicator(
        onRefresh: onRefresh,
        child: Container(
          height: SizeConfig.screenHeight,
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: inquiries.length,
            itemBuilder: (BuildContext context, int index) =>
                inquiryItemBuilder(context, inquiries[index], index),
          ),
        ),
      ),
    );
  }
}
