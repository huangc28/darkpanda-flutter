import 'dart:async';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/contracts/chatroom.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/models/inquiry.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';

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

  Inquiry inquiryDetail;

  InquiryChatroomsBloc _inquiryChatroomsBloc;

  bool pickupIsLoading = false;

  // To use for button loading equal to specific inquiry uuid,
  // so only one button will showing loading instead of all button
  String inquiryUuid = "";

  @override
  initState() {
    _refreshCompleter = Completer();
    _inquiryChatroomsBloc = BlocProvider.of<InquiryChatroomsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _inquiryChatroomsBloc.add(ClearInquiryChatList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            BlocListener<PickupInquiryBloc, PickupInquiryState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.initial ||
                    state.status == AsyncLoadingStatus.loading) {
                  setState(() {
                    pickupIsLoading = true;
                  });
                }
                // Show message when error occured when picking up inquiry.
                if (state.status == AsyncLoadingStatus.error) {
                  setState(() {
                    pickupIsLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error.message,
                      ),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  setState(() {
                    pickupIsLoading = false;
                  });
                }
              },
              child: Container(),
            ),
            BlocConsumer<InquiriesBloc, InquiriesState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.initial ||
                    state.status == AsyncLoadingStatus.loading) {}

                if (state.status == AsyncLoadingStatus.done) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();
                }

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

                  Navigator.of(context, rootNavigator: true).pop();
                }

                return null;
              },

              // We use `Expanded` widget to make the child `Container` takes over
              // the rest of the height of the `Column`. The `InquiryList` (`ListView.builder`)
              // can then render the list of grids utilizing the within the full height container.
              // @Ref: https://stackoverflow.com/questions/49480051/flutter-dart-exceptions-caused-by-rendering-a-renderflex-overflowed
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
                    child: InquiryList(
                      onLoadMore: () {
                        BlocProvider.of<InquiriesBloc>(context).add(
                          LoadMoreInquiries(),
                        );
                      },
                      onRefresh: () {
                        BlocProvider.of<InquiriesBloc>(context).add(
                          FetchInquiries(
                            nextPage: 1,
                          ),
                        );

                        return _refreshCompleter.future;
                      },
                      inquiryItemBuilder: (context, inquiry, ___) =>
                          InquiryGrid(
                        inquiry: inquiry,
                        onTapPickup: _handleTapPickup,
                        onTapStartChat: _handleStartChat,
                        onTapClear: _handleClearInquiry,
                        onTapCheckProfile: (String userUuid) {
                          widget.onPush(
                            '/inquirer-profile',
                            InquirerProfileArguments(
                              uuid: userUuid,
                            ),
                          );
                        },
                        isLoading: pickupIsLoading,
                        inquiryUuid: inquiryUuid,
                      ),
                      inquiries: state.inquiries,
                    ),
                  ),
                );
              },
            ),
            // Fetch inquiry chatrooms
            BlocListener<InquiryChatroomsBloc, InquiryChatroomsState>(
              listener: (context, state) {
                print('state.status ${state.status}');

                if (state.status == AsyncLoadingStatus.loading ||
                    state.status == AsyncLoadingStatus.initial) {
                  return Row(
                    children: [
                      LoadingScreen(),
                    ],
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    MainRoutes.femaleInquiryChatroom,
                    arguments: FemaleInquiryChatroomScreenArguments(
                      channelUUID: inquiryDetail.channelUuid,
                      inquiryUUID: inquiryDetail.uuid,
                      counterPartUUID: inquiryDetail.inquirer.uuid,
                      serviceType: inquiryDetail.serviceType,
                      routeTypes: RouteTypes.fromInquiryList,
                      serviceUUID: inquiryDetail.serviceUuid,
                    ),
                  );
                }
              },
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.screenHeight * 0.034, //30,
        right: SizeConfig.screenWidth * 0.038, //16,
        left: SizeConfig.screenWidth * 0.038, //16,
      ),
      child: Row(
        children: <Widget>[
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

  _handleStartChat(Inquiry inquiry) {
    print('start _handleStartChat');

    // We need to redirect female to chatroom and clear the inquiry
    // item from inquiry list.
    inquiryDetail = inquiry;
    _inquiryChatroomsBloc.add(FetchChatrooms());
  }

  _handleClearInquiry(String uuid) {
    BlocProvider.of<InquiriesBloc>(context).add(
      RemoveInquiry(
        inquiryUuid: uuid,
      ),
    );
  }

  _handleTapPickup(String uuid) {
    inquiryUuid = uuid;
    // Emit chat now event to try to start an inquiry chat.
    BlocProvider.of<PickupInquiryBloc>(context).add(
      PickupInquiry(
        uuid: uuid,
      ),
    );
  }
}
