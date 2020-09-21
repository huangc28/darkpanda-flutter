import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/inquiries_bloc.dart';
import './components/inquiry_grid.dart';

// Render list of inquires emitted by the male users.
// @TODOs
//   - seed male sample data - [ok]
//   - view male inquiry data - [ok]
//   - accept male inquiry
//   - go straight to the chatroom
class InqiuryList extends StatelessWidget {
  // List of inquiry
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<InquiriesBloc, InquiriesState>(
        builder: (context, state) {
          if (state.status == FetchInquiryStatus.fetched) {
            return Scaffold(
              body: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.inquiries.length,
                itemBuilder: (BuildContext context, int idx) {
                  return InquiryGrid(
                    key: UniqueKey(),
                    inquiry: state.inquiries[idx],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 1,
                ),
              ),
            );
          }

          if (state.status == FetchInquiryStatus.fetching) {
            return Container(
              child: Text('fetching'),
            );
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
