import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show InquiryDetail, ServiceChatroomScreenArguments;
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/body.dart';

class CompleteBuyService extends StatefulWidget {
  const CompleteBuyService({this.args});

  final InquiryDetail args;

  @override
  _CompleteBuyServiceState createState() => _CompleteBuyServiceState();
}

class _CompleteBuyServiceState extends State<CompleteBuyService> {
  LoadIncomingServiceBloc _loadIncomingServiceBloc;
  int isFirstCall = 0;

  @override
  void initState() {
    super.initState();

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
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 16, 41, 1),
          automaticallyImplyLeading: false,
          title: Text('支付'),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1),
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
          child: Body(
            args: widget.args,
            onGoToServiceChatroom: () {
              BlocProvider.of<LoadIncomingServiceBloc>(context)
                  .add(LoadIncomingService());
            },
          ),
        ),
      ),
    );
  }
}
