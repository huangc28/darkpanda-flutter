import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/inquiries_bloc.dart';
import './components/inquiry_grid.dart';
import '../../models/inquiry.dart';

// Render list of inquires emitted by the male users.
// @TODOs
//   - seed male sample data - [ok]
//   - view male inquiry data - [ok]
//   - accept male inquiry
//   - tap go straight to the chatroom
//   - add circular loading icon when fetching inquiries
//   - display failed message
class InqiuryList extends StatefulWidget {
  // List of inquiry
  @override
  _InqiuryListState createState() => _InqiuryListState();
}

class _InqiuryListState extends State<InqiuryList> {
  /// The purpose of a completer is to convert callback-based API into
  /// a future based one.
  /// Please refer to [official documentation](https://api.flutter.dev/flutter/dart-async/Completer-class.html)
  Completer<void> _refreshCompleter;

  @override
  initState() {
    _refreshCompleter = new Completer<void>();

    super.initState();
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
        BlocProvider.of<InquiriesBloc>(context).add(FetchInquiries());
        return _refreshCompleter.future;
      },
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: inquiries.length,
        itemBuilder: (BuildContext context, int idx) {
          return InquiryGrid(
            key: UniqueKey(),
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
      child: BlocBuilder<InquiriesBloc, InquiriesState>(
        builder: (context, state) {
          if (state.status == FetchInquiryStatus.fetched) {
            return Scaffold(
              body: _buildInquiryList(state.inquiries),
            );
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
    );
  }
}
