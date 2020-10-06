import 'dart:async';
import 'package:flutter/material.dart';

import '../../../models/inquiry.dart';

typedef InquiryItemBuilder = Widget Function(
    BuildContext context, Inquiry inquiry, int index);

class InquiryList extends StatefulWidget {
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
  _InquiryListState createState() => _InquiryListState();
}

class _InquiryListState extends State<InquiryList> {
  Timer _loadMoreDebounce;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    // We need to add debounce mechanism, to prevent large invocations,
    final offsetFromScrollExtent = 10;

    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - offsetFromScrollExtent) {
      if (_loadMoreDebounce != null) {
        _loadMoreDebounce.cancel();
      }

      _loadMoreDebounce = Timer(const Duration(milliseconds: 500),
          () => new Future.delayed(Duration.zero, widget.onLoadMore));
    }
  }

  @override
  dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.inquiries.length,
            itemBuilder: (BuildContext context, int idx) =>
                widget.inquiryItemBuilder(context, widget.inquiries[idx], idx),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
            ),
          ),
        ),
      );
}
