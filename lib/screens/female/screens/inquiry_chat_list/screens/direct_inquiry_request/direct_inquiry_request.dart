import 'dart:async';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/inquirer_profile_arguments.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/inquirer_profile.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import 'bloc/load_direct_inquiry_request_bloc.dart';
import 'components/direct_inquiry_request_grid.dart';
import 'components/direct_inquiry_request_list.dart';

class DirectInquiryRequest extends StatefulWidget {
  const DirectInquiryRequest({Key key}) : super(key: key);

  @override
  _DirectInquiryRequestState createState() => _DirectInquiryRequestState();
}

class _DirectInquiryRequestState extends State<DirectInquiryRequest> {
  Completer<void> _refreshCompleter;

  @override
  initState() {
    super.initState();

    _refreshCompleter = Completer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          BlocConsumer<LoadDirectInquiryRequestBloc,
              LoadDirectInquiryRequestState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.error) {
                _refreshCompleter.completeError(state.error);
                _refreshCompleter = Completer();

                developer.log(
                  'failed to refetch inquiries',
                  error: state.error,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                  ),
                );

                // Navigator.of(context, rootNavigator: true).pop();
              }

              if (state.status == AsyncLoadingStatus.done) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
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
                    onLoadMore: () {
                      BlocProvider.of<LoadDirectInquiryRequestBloc>(context)
                          .add(
                        LoadMorehDirectInquiries(),
                      );
                    },
                    onRefresh: () {
                      BlocProvider.of<LoadDirectInquiryRequestBloc>(context)
                          .add(
                        FetchDirectInquiries(),
                      );

                      return _refreshCompleter.future;
                    },
                    inquiries: state.inquiries,
                    inquiryItemBuilder: (context, inquiry, ___) {
                      return inquiry.inquiryStatus != InquiryStatus.canceled
                          ? DirectInquiryRequestGrid(
                              inquiry: inquiry,
                              onTapSkip: _handleSkip,
                              onTapViewProfile: _handleViewProfile,
                            )
                          : Container();
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

  _handleSkip(String uuid) {
    BlocProvider.of<CancelInquiryBloc>(context).add(
      CancelInquiry(inquiryUuid: uuid),
    );
  }

  _handleViewProfile(String inquirerUuid) {
    InquirerProfileArguments _inquirerProfileArguments =
        InquirerProfileArguments(uuid: inquirerUuid);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadUserImagesBloc(
                  userApi: UserApis(),
                ),
              ),
              BlocProvider(
                create: (context) => LoadRateBloc(
                  rateApiClient: RateApiClient(),
                ),
              ),
            ],
            child: InquirerProfile(
              loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
              args: _inquirerProfileArguments,
            ),
          );
        },
      ),
    );
  }
}
