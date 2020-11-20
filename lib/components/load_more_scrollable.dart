import 'dart:async';
import 'package:flutter/material.dart';

class LoadMoreScrollable extends StatefulWidget {
  LoadMoreScrollable({
    @required this.builder,
    @required this.onLoadMore,
    this.reverse = false,
    this.scrollController,
  });

  final Widget Function(BuildContext, ScrollController) builder;
  final Function onLoadMore;
  final bool reverse;
  final ScrollController scrollController;

  @override
  _LoadMoreScrollableState createState() => _LoadMoreScrollableState();
}

class _LoadMoreScrollableState extends State<LoadMoreScrollable> {
  Timer _loadMoreDebounce;

  ScrollController _scrollController;
  Function _scrollListener;

  @override
  void initState() {
    super.initState();

    _scrollListener =
        widget.reverse ? _detectTopScrollListener : _detectBottomScrollListener;

    _scrollController = widget.scrollController ?? new ScrollController();

    _scrollController.addListener(_scrollListener);
  }

  void _detectTopScrollListener() {
    final offsetFromScrollTop = 10;

    if (_scrollController.position.pixels < 0.0 + offsetFromScrollTop) {
      if (_loadMoreDebounce != null) {
        _loadMoreDebounce.cancel();
      }

      _loadMoreDebounce = Timer(const Duration(milliseconds: 500),
          () => new Future.delayed(Duration.zero, widget.onLoadMore));
    }
  }

  void _detectBottomScrollListener() {
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
  Widget build(BuildContext context) {
    return Container(
      child: widget.builder(context, _scrollController),
    );
  }
}
