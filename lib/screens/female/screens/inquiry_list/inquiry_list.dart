import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import './bloc/inquiries_bloc.dart';
import './bloc/pickup_inquiry_bloc.dart';
import './components/inquiry_grid.dart';
import './components/inquiry_list.dart';

typedef OnPushInquiryDetail = void Function(
    String routeName, Map<String, dynamic> args);

// TODOs:
//   - Complete `check profile` function.
//   - Complete `hide inquiry` function when pickup is denied.
class InqiuryList extends StatefulWidget {
  const InqiuryList({
    this.onPush,
  });

  final OnPushInquiryDetail onPush;

  @override
  _InqiuryListState createState() => _InqiuryListState();
}

class _InqiuryListState extends State<InqiuryList> {
  /// The purpose of a completer is to convert callback-based API into
  /// a future based one.
  /// Please refer to [official documentation](https://api.flutter.dev/flutter/dart-async/Completer-class.html)
  Completer<void> _refreshCompleter;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  initState() {
    _refreshCompleter = Completer();
    super.initState();
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 16,
        left: 16,
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '需求總覽',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            BlocListener<PickupInquiryBloc, PickupInquiryState>(
              listener: (context, state) {
                // Show message when error occured when picking up inquiry.
                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error.message,
                      ),
                    ),
                  );
                }
              },
              child: Container(),
            ),
            BlocConsumer<InquiriesBloc, InquiriesState>(
              listener: (context, state) {
                if (state.status == FetchInquiryStatus.initial ||
                    state.status == FetchInquiryStatus.fetching) {
                  // Dialogs.showLoadingDialog(context, _keyLoader);
                  print('fetch inquiries');
                }

                if (state.status == FetchInquiryStatus.fetched) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();

                  print('fetch inquiries done');
                  // Dialogs.closeLoadingDialog(context);
                }

                if (state.status == FetchInquiryStatus.fetchFailed) {
                  _refreshCompleter.completeError(state.error);
                  _refreshCompleter = Completer();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );

                  Navigator.of(context, rootNavigator: true).pop();
                }

                return null;
              },

              // We use `Expanded` widget to make the child `Container` takes over
              // the rest of the height of the `Column`. The `InquiryList` (`ListView.builder`)
              // can then render the list of grids utilizing the within the full height container.
              // @Ref: https://stackoverflow.com/questions/49480051/flutter-dart-exceptions-caused-by-rendering-a-renderflex-overflowed
              builder: (context, state) => Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 25,
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  child: InquiryList(
                    onLoadMore: () {
                      print('DEBUG trigger load more');
                    },
                    onRefresh: () {
                      BlocProvider.of<InquiriesBloc>(context).add(
                        FetchInquiries(
                          nextPage: 1,
                        ),
                      );

                      return _refreshCompleter.future;
                    },
                    inquiryItemBuilder: (context, inquiry, ___) => InquiryGrid(
                      inquiry: inquiry,
                      onTapAvatar: (String uuid) {
                        print('DEBUG trigger on push avatar');
                        // widget.onPush(
                        //   InquiriesRoutes.inquirerProfile,
                        //   {
                        //     'uuid': uuid,
                        //   },
                        // );
                      },
                      onTapChat: _handleTapChat,
                      onTapClear: _handleClearInquiry,
                    ),
                    inquiries: state.inquiries,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleClearInquiry(String uuid) {
    print('DEBUG trigger _handleClearInquiry');
    BlocProvider.of<PickupInquiryBloc>(context).add(
      RemovePickedupInquiry(
        uuid: uuid,
      ),
    );
  }

  _handleTapChat(String uuid) {
    // Emit chat now event to try to start an inquiry chat.
    BlocProvider.of<PickupInquiryBloc>(context).add(
      PickupInquiry(
        uuid: uuid,
      ),
    );
  }
}
