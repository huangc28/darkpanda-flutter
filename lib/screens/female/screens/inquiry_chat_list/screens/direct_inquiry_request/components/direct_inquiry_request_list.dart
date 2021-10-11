import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/components/load_more_scrollable.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/models/inquiry.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/components/inquiry_list.dart';

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

  final List<Inquiry> inquiries;

  final InquiryItemBuilder inquiryItemBuilder;

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
