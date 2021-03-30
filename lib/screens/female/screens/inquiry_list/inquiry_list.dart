import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dialogs.dart';

import './routes.dart';
import './bloc/inquiries_bloc.dart';
import './bloc/pickup_inquiry_bloc.dart';
import './components/inquiry_grid.dart';
import './components/inquiry_list.dart';

typedef OnPushInquiryDetail = void Function(
    String routeName, Map<String, dynamic> args);

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
            BlocConsumer<InquiriesBloc, InquiriesState>(
              listener: (context, state) {
                if (state.status == FetchInquiryStatus.initial ||
                    state.status == FetchInquiryStatus.fetching) {
                  Dialogs.showLoadingDialog(context, _keyLoader);
                }

                if (state.status == FetchInquiryStatus.fetched) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();
                  Navigator.of(context, rootNavigator: true).pop();
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
              builder: (context, state) => Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 25,
                    bottom: 20,
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
                        widget.onPush(
                          InquiriesRoutes.inquirerProfile,
                          {
                            'uuid': uuid,
                          },
                        );
                      },
                      onTapPickup: _handleTapPickup,
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

  _handleTapPickup(String uuid) {
    BlocProvider.of<PickupInquiryBloc>(context).add(PickupInquiry(uuid: uuid));
  }
}
