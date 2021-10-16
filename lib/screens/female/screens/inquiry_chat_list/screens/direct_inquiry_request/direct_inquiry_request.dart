import 'dart:async';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/chatroom.dart';
import 'package:darkpanda_flutter/screens/male/bloc/agree_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/agree_inquiry_response.dart';
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
  const DirectInquiryRequest({
    Key key,
    this.onTabBarChanged,
  }) : super(key: key);

  final ValueChanged<int> onTabBarChanged;

  @override
  _DirectInquiryRequestState createState() => _DirectInquiryRequestState();
}

class _DirectInquiryRequestState extends State<DirectInquiryRequest> {
  Completer<void> _refreshCompleter;

  AgreeInquiryResponse agreeInquiryResponse = new AgreeInquiryResponse();
  bool _agreeToChatIsLoading = false;

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
                              onTapAgreeToChat: _handleAgreeToChat,
                              onTapViewProfile: _handleViewProfile,
                              onTapStartToChat: _handleStartToChat,
                              agreeToChatIsLoading: _agreeToChatIsLoading,
                            )
                          : Container();
                    },
                  ),
                ),
              );
            },
          ),
          BlocListener<AgreeInquiryBloc, AgreeInquiryState>(
            listener: (context, state) {
              if (state.status == AsyncLoadingStatus.initial ||
                  state.status == AsyncLoadingStatus.loading) {
                setState(() {
                  _agreeToChatIsLoading = true;
                });
              }

              if (state.status == AsyncLoadingStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                  ),
                );
              }

              if (state.status == AsyncLoadingStatus.done) {
                agreeInquiryResponse = state.agreeInquiry;
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }

  _handleSkip(String inquiryUuid) {
    BlocProvider.of<CancelInquiryBloc>(context).add(
      CancelInquiry(inquiryUuid: inquiryUuid),
    );
  }

  _handleAgreeToChat(String inquiryUuid) {
    BlocProvider.of<AgreeInquiryBloc>(context).add(AgreeInquiry(inquiryUuid));
  }

  _handleStartToChat(String inquiryUuid) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(
      MainRoutes.chatroom,
      arguments: ChatroomScreenArguments(
        channelUUID: agreeInquiryResponse.channelUuid,
        inquiryUUID: inquiryUuid,
        counterPartUUID: agreeInquiryResponse.inquirer.uuid,
        serviceType: agreeInquiryResponse.serviceType,
        routeTypes: RouteTypes.fromInquiryChats,
        serviceUUID: agreeInquiryResponse.serviceUuid,
      ),
    );

    // Change tab to 聊天室 because current tab is 聊天請求
    // After user back from chatroom will show 聊天室
    widget.onTabBarChanged(1);
  }

  _handleViewProfile(String inquirerUuid) {
    InquirerProfileArguments _inquirerProfileArguments =
        InquirerProfileArguments(uuid: inquirerUuid);

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(
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
