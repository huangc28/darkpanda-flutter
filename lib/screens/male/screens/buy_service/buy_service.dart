import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/gender.dart';
import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:darkpanda_flutter/enums/service_cancel_cause.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/routes.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/load_cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/service_chatroom.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import '../../bottom_navigation.dart';
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
  int isFirstCall = 0;

  String _gender;
  String _cancelCause;

  AsyncLoadingStatus _cancelServiceStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    _getGender().then((value) {
      _gender = value;
    });

    _loadIncomingServiceBloc =
        BlocProvider.of<LoadIncomingServiceBloc>(context);
  }

  @override
  void dispose() {
    _loadIncomingServiceBloc.add(ClearIncomingServiceState());

    super.dispose();
  }

  Future<String> _getGender() async {
    return await SecureStore().readGender();
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
        appBar: _appBar(),
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
                    print(
                        '[Debug] 2 LoadIncomingServiceBloc ------------------------------------------');
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
                setState(() {
                  _cancelServiceStatus = state.status;
                });

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

                  // If route is from service_chatroom, should use pop
                  if (widget.args.routeTypes ==
                      RouteTypes.fromServiceChatroom) {
                    Navigator.of(context).pop();
                  }
                  // 1. Route is from inquiry_chatroom
                  else {
                    print(
                        '[Debug] 1 CancelServiceBloc ------------------------------------------');
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil(
                      MainRoutes.male,
                      ModalRoute.withName('/'),
                      arguments: MaleAppTabItem.manage,
                    );
                  }
                }
              },
            ),
            BlocListener<LoadCancelServiceBloc, LoadCancelServiceState>(
                listener: (context, state) {
              if (state.status == AsyncLoadingStatus.done) {
                // _serviceCancelCause(
                //     state.loadCancelServiceResponse.cancelCause);

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
                    BlocProvider.of<CancelServiceBloc>(context).add(
                        CancelService(serviceUuid: widget.args.serviceUuid));
                  }
                });
              }

              if (state.status == AsyncLoadingStatus.error) {
                developer.log(
                  'failed to fetch payment detail',
                  error: state.error,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error.message),
                  ),
                );
              }

              setState(() {
                _cancelServiceStatus = state.status;
              });
            }),
          ],
          child: Body(
            args: widget.args,
            cancelServiceStatus: _cancelServiceStatus,
            onBuyService: () {},
            onCancelService: () {
              BlocProvider.of<LoadCancelServiceBloc>(context).add(
                LoadCancelService(serviceUuid: widget.args.serviceUuid),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      leadingWidth: 85,
      leading: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(106, 109, 137, 1),
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
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
    );
  }
}
