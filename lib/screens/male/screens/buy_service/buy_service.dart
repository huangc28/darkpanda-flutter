import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/body.dart';
import 'components/buy_service_cancel_confirmation_dialog.dart';

class BuyService extends StatefulWidget {
  const BuyService({
    this.args,
  });

  final InquiryDetail args;

  @override
  _BuyServiceState createState() => _BuyServiceState();
}

class _BuyServiceState extends State<BuyService> {
  LoadIncomingServiceBloc _loadIncomingServiceBloc;
  int isFirstCall;

  @override
  void initState() {
    super.initState();

    isFirstCall = 0;

    _loadIncomingServiceBloc =
        BlocProvider.of<LoadIncomingServiceBloc>(context);
  }

  @override
  void dispose() {
    _loadIncomingServiceBloc.add(ClearIncomingServiceState());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If route is from service_chatroom, should use pop
        if (widget.args.routeTypes == RouteTypes.fromServiceChatroom) {
          Navigator.of(context).pop();
        }
        // 1. Route is from inquiry_chatroom
        // 2. From service_chatroom to topup_dp
        else {
          BlocProvider.of<LoadIncomingServiceBloc>(context)
              .add(LoadIncomingService());
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          leadingWidth: 85,
          leading: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(106, 109, 137, 1),
                ),
                onPressed: () {
                  // If route is from service_chatroom, should use pop
                  if (widget.args.routeTypes ==
                      RouteTypes.fromServiceChatroom) {
                    Navigator.of(context).pop();
                  }
                  // 1. Route is from inquiry_chatroom
                  // 2. From service_chatroom to topup_dp
                  else {
                    BlocProvider.of<LoadIncomingServiceBloc>(context)
                        .add(LoadIncomingService());
                  }
                },
              ),
              Text(
                '聊天',
                style: TextStyle(
                  color: Color.fromRGBO(106, 109, 137, 1),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          title: Text('交易'),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.loading ||
                    state.status == AsyncLoadingStatus.initial) {
                  return Row(
                    children: [
                      LoadingScreen(),
                    ],
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  isFirstCall++;

                  // status done will be called twice, so implement isFirstCall to solve this issue
                  if (isFirstCall == 1) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(
                      MainRoutes.serviceChatroom,
                      arguments: ServiceChatroomScreenArguments(
                        channelUUID: widget.args.channelUuid,
                        inquiryUUID: widget.args.inquiryUuid,
                        counterPartUUID: widget.args.counterPartUuid,
                        serviceUUID: widget.args.serviceUuid,
                        routeTypes: RouteTypes.fromBuyService,
                      ),
                    );
                  }
                }
              },
            ),
            BlocListener<CancelServiceBloc, CancelServiceState>(
              listener: (context, state) {
                if (state.status == AsyncLoadingStatus.loading ||
                    state.status == AsyncLoadingStatus.initial) {
                  return Row(
                    children: [
                      LoadingScreen(),
                    ],
                  );
                }

                if (state.status == AsyncLoadingStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error.message),
                    ),
                  );
                }

                if (state.status == AsyncLoadingStatus.done) {
                  print('Service cancelled');
                }
              },
            ),
          ],
          child: Body(
            args: widget.args,
            onBuyService: () {},
            onCancelService: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return BuyServiceCancelConfirmationDialog(
                    matchingFee: widget.args.updateInquiryMessage.matchingFee,
                  );
                },
              ).then((value) {
                if (value) {
                  BlocProvider.of<CancelServiceBloc>(context)
                      .add(CancelService(serviceUuid: widget.args.serviceUuid));
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
