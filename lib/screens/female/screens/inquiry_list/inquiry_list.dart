import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/inquiries_bloc.dart';
import './bloc/load_more_inquiries_bloc.dart';
import './components/inquiry_grid.dart';
import '../../models/inquiry.dart';

// Render list of inquires emitted by the male users.
// @TODOs
//   - seed male sample data - [ok]
//   - view male inquiry data - [ok]
//   - accept male inquiry
//   - tap go straight to the chatroom
//   - add circular loading icon when fetching inquiries - [ok]
//   - add refresh indicator - [ok]
//   - display failed message - [ok]
//   - add loadmore listener
class InqiuryList extends StatefulWidget {
  // List of inquiry
  @override
  _InqiuryListState createState() => _InqiuryListState();
}

class _InqiuryListState extends State<InqiuryList> {
  _InqiuryListState() : super() {
    _refreshCompleter = new Completer<void>();
  }

  /// The purpose of a completer is to convert callback-based API into
  /// a future based one.
  /// Please refer to [official documentation](https://api.flutter.dev/flutter/dart-async/Completer-class.html)
  Completer<void> _refreshCompleter;

  ScrollController _scrollController;

  Timer _loadMoreDebounce;
  @override
  initState() {
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  /// @TODO extract this part of the logic to `loadMoreDebouncer` widget
  /// to be reusable.
  _scrollListener() {
    // We need to add debounce mechanism, to prevent large invocations,
    final offsetFromScrollExtent = 10;

    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - offsetFromScrollExtent) {
      if (_loadMoreDebounce != null) {
        _loadMoreDebounce.cancel();
      }

      _loadMoreDebounce = Timer(
          const Duration(milliseconds: 500),
          () => new Future.delayed(Duration.zero, () {
                BlocProvider.of<LoadMoreInquiriesBloc>(context)
                    .add(LoadMoreInquiries(
                  nextPage: BlocProvider.of<InquiriesBloc>(context)
                          .state
                          .currentPage +
                      1,
                ));
              }));
    }
  }

  _handleTap({
    BuildContext context,

    /// inquiry uuid necessary to load inquiry detail
    String uuid,
  }) {
    // proceed to inquiry detail page

    Navigator.pushNamed(context, '/register');
    print('DEBUG trigger on tap');
  }

  Widget _buildInquiryList(List<Inquiry> inquiries) {
    return RefreshIndicator(
      onRefresh: () {
        // emit event to fetch inquiry list again
        // toggles completer to indicate future
        BlocProvider.of<InquiriesBloc>(context).add(FetchInquiries(
          nextPage: 1,
        ));
        return _refreshCompleter.future;
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: inquiries.length,
        itemBuilder: (BuildContext context, int idx) {
          return InquiryGrid(
            inquiry: inquiries[idx],
            onTap: ({String uuid}) => _handleTap(
              context: context,
              uuid: uuid,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<InquiriesBloc, InquiriesState>(
          listener: (context, state) {
            if (state.status == FetchInquiryStatus.fetched) {
              _refreshCompleter.complete();
            }

            if (state.status == FetchInquiryStatus.fetchFailed) {
              _refreshCompleter.completeError(null);
            }

            _refreshCompleter = new Completer<void>();

            return null;
          },
          builder: (context, state) {
            if (state.status == FetchInquiryStatus.fetched) {
              return _buildInquiryList(state.inquiries);
            }

            if (state.status == FetchInquiryStatus.fetchFailed) {
              return Center(
                child: Text(state.error.message),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
              ),
            );
          },
        ),
      ),
    );
  }
}
