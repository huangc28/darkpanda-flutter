import 'dart:async';
import 'package:flutter/material.dart';

class LoadMoreScrollable extends StatefulWidget {
  LoadMoreScrollable({
    @required this.builder,
    @required this.onLoadMore,
  });

  final Widget Function(BuildContext, ScrollController) builder;
  final Function onLoadMore;

  @override
  _LoadMoreScrollableState createState() => _LoadMoreScrollableState();
}

class _LoadMoreScrollableState extends State<LoadMoreScrollable> {
  Timer _loadMoreDebounce;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
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
