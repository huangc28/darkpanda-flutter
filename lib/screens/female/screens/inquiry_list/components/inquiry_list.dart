import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/load_more_scrollable.dart';

import '../../../models/inquiry.dart';

typedef InquiryItemBuilder = Widget Function(
    BuildContext context, Inquiry inquiry, int index);

class InquiryList extends StatelessWidget {
  const InquiryList({
    @required this.inquiryItemBuilder,
    @required this.inquiries,
    this.onLoadMore,
    this.onRefresh,
  });

  final InquiryItemBuilder inquiryItemBuilder;

  final List<Inquiry> inquiries;

  final Function onRefresh;

  final Function onLoadMore;

  @override
  Widget build(BuildContext context) => Container(
        child: LoadMoreScrollable(
          onLoadMore: onLoadMore,
          builder: (context, scrollController) => RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: inquiries.length,
              itemBuilder: (BuildContext context, int idx) =>
                  inquiryItemBuilder(context, inquiries[idx], idx),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 1,
              ),
            ),
          ),
        ),
      );
}
