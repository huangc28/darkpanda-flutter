import 'dart:async';

import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/create_inquiry.dart';
import 'components/waiting_inquiry.dart';
import 'components/chat_request.dart';

typedef OnPushInquiryDetail = void Function(
    String routeName, InquirerProfileArguments args);

class SearchInquiry extends StatefulWidget {
  const SearchInquiry({
    this.onPush,
  });

  final OnPushInquiryDetail onPush;

  @override
  _SearchInquiryState createState() => _SearchInquiryState();
}

class _SearchInquiryState extends State<SearchInquiry> {
  Completer<void> _refreshCompleter;
  ActiveInquiry activeInquiry = new ActiveInquiry();

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer();
    BlocProvider.of<LoadInquiryBloc>(context).add(LoadInquiry());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoadInquiryBloc, LoadInquiryState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            _refreshCompleter.completeError(state.error);
            _refreshCompleter = Completer();
          } else if (state.status == AsyncLoadingStatus.done) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
            setState(() {
              activeInquiry = state.activeInquiry;
            });
          }
        },
        builder: (context, state) {
          if (state.status == AsyncLoadingStatus.initial ||
              state.status == AsyncLoadingStatus.loading) {
            return Row(
              children: [
                LoadingScreen(),
              ],
            );
          } else if (state.status == AsyncLoadingStatus.done) {
            // 1. Inquiry status == inquiring, go to Waiting Inquiry screen
            if (state.activeInquiry.inquiryStatus == InquiryStatus.inquiring) {
              return WaitingInquiry(activeInquiry: activeInquiry);
            }

            // 2. Inquiry status == cancelled, go to Create Inquiry screen
            else if (state.activeInquiry.inquiryStatus ==
                InquiryStatus.canceled) {
              return CreateInquiry();
            }

            // 3. Inquiry status == asking, go to Chat Request screen
            return ChatRequest(
                onPush: widget.onPush, activeInquiry: activeInquiry);
          }

          // Male does not has active inquiry, go to Create Inquiry screen
          else if (state.status == AsyncLoadingStatus.error) {
            return CreateInquiry();
          }

          // Default go to Create Inquiry screen
          return CreateInquiry();
        },
      ),
    );
  }
}
