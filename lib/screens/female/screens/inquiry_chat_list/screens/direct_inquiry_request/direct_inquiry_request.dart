import 'dart:developer' as developer;

import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/load_direct_inquiry_request_bloc.dart';
import 'components/direct_inquiry_request_grid.dart';
import 'components/direct_inquiry_request_list.dart';

class DirectInquiryRequest extends StatefulWidget {
  const DirectInquiryRequest({Key key}) : super(key: key);

  @override
  _DirectInquiryRequestState createState() => _DirectInquiryRequestState();
}

class _DirectInquiryRequestState extends State<DirectInquiryRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          BlocConsumer<LoadDirectInquiryRequestBloc,
              LoadDirectInquiryRequestState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.error) {
                // _refreshCompleter.completeError(state.error);
                // _refreshCompleter = Completer();

                developer.log(
                  'failed to refetch inquiries',
                  error: state.error,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                  ),
                );

                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            builder: (context, state) {
              if (state.status == AsyncLoadingStatus.loading ||
                  state.status == AsyncLoadingStatus.initial) {
                return LoadingScreen();
              }

              return Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screenHeight * 0.028, //25,
                    bottom: SizeConfig.screenHeight * 0.022, //20,
                    left: SizeConfig.screenWidth * 0.038, //16,
                    right: SizeConfig.screenWidth * 0.038, //16,
                  ),
                  height: SizeConfig.screenHeight * 0.2,
                  child: DirectInquiryRequestList(
                    onLoadMore: () {},
                    onRefresh: () {},
                    inquiries: state.inquiries,
                    inquiryItemBuilder: (context, inquiry, ___) {
                      return DirectInquiryRequestGrid(
                        inquiry: inquiry,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
