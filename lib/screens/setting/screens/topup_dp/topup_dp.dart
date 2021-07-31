import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';

import 'components/body.dart';
import 'screen_arguements/args.dart';

class TopupDp extends StatefulWidget {
  const TopupDp({
    this.args,
    this.onPush,
  });

  final InquiryDetail args;
  final Function(String, TopUpDpArguments) onPush;

  @override
  _TopupDpState createState() => _TopupDpState();
}

class _TopupDpState extends State<TopupDp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If widget.args is null, means is from settings
        if (widget.args == null) {
          Navigator.of(context).pop();
        }
        // If route is from service_chatroom, should use pop
        else if (widget.args.routeTypes == RouteTypes.fromServiceChatroom) {
          Navigator.of(context).pop();
        }
        // 1. If widget.args is not null, means is from male inquiry
        // 2. Or route is from inquiry_chatroom
        else {
          BlocProvider.of<LoadIncomingServiceBloc>(context)
              .add(LoadIncomingService());
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          title: Text('DP幣'),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(106, 109, 137, 1),
            ),
            onPressed: () {
              // If widget.args is null, means is from settings
              if (widget.args == null) {
                Navigator.of(context).pop();
              }
              // If route is from service_chatroom, should use pop
              else if (widget.args.routeTypes ==
                  RouteTypes.fromServiceChatroom) {
                Navigator.of(context).pop();
              }
              // 1. If widget.args is not null, means is from male inquiry
              // 2. Or route is from inquiry_chatroom
              else {
                BlocProvider.of<LoadIncomingServiceBloc>(context)
                    .add(LoadIncomingService());
              }
            },
          ),
        ),
        body: BlocListener<LoadIncomingServiceBloc, LoadIncomingServiceState>(
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
          },
          child: Body(
            onPush: widget.onPush,
            args: widget.args,
          ),
        ),
      ),
    );
  }
}
