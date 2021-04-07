import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import './bloc/inquiries_bloc.dart';
import './bloc/pickup_inquiry_bloc.dart';
import './components/inquiry_grid.dart';
import './components/inquiry_list.dart';
import './screen_arguments/args.dart';

typedef OnPushInquiryDetail = void Function(
    String routeName, InquirerProfileArguments args);

// TODOs:
//   - Complete `check profile` function.
//   - Complete `hide inquiry` function when pickup is denied. [ok]
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
                if (state.status == AsyncLoadingStatus.initial ||
                    state.status == AsyncLoadingStatus.loading) {
                  print('fetch inquiries');
                }

                if (state.status == AsyncLoadingStatus.done) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();

                  print('fetch inquiries done');
                }

                if (state.status == AsyncLoadingStatus.error) {
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
                      onTapChat: _handleTapChat,
                      onTapStartChat: _handleStartChat,
                      onTapClear: _handleClearInquiry,
                      onTapCheckProfile: (String userUuid) {
                        print('trigger onTapCheckProfile ${userUuid}');

                        widget.onPush(
                          '/inquirer-profile',
                          InquirerProfileArguments(
                            uuid: userUuid,
                          ),
                        );
                      },
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

  _handleStartChat(String uuid) {
    print('DEBUG handle start chatting ${uuid}');
    // We need to redirect female to chatroom and clear the inquiry
    // item from inquiry list.
    // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatRooms()));
  }

  _handleClearInquiry(String uuid) {
    BlocProvider.of<InquiriesBloc>(context).add(
      RemoveInquiry(
        inquiryUuid: uuid,
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
