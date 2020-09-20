import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/inquiries_bloc.dart';

// Render list of inquires emitted by the male users.
// @TODOs
//   - seed male sample data
//   - view male inquiry data
//   - accept male inquiry
//   - go straight to the chatroom
class InqiuryList extends StatefulWidget {
  final InquiriesBloc inquiriesBloc;

  InqiuryList({this.inquiriesBloc});

  @override
  _InqiuryListState createState() => _InqiuryListState();
}

class _InqiuryListState extends State<InqiuryList> {
  @override
  initState() {
    // Emit fetching inquiries
    widget.inquiriesBloc.add(FetchInquiries());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.inquiriesBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<InquiriesBloc, InquiriesState>(
        builder: (context, state) {
          print('DEBUG state ${state.status}');
          if (state.status == FetchInquiryStatus.fetched) {
            print('DEBUG state ${state.inquiries}');
          }

          return Scaffold(
            body: Container(
              child: Text('female inquiry page'),
            ),
          );
        },
      ),
    );
  }
}
