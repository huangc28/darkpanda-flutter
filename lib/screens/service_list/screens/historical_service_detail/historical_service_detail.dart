import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/models/rate_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_payment_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_rate_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/rate/bloc/send_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/rate/rate.dart';
import 'package:darkpanda_flutter/screens/service_list/services/service_chatroom_api.dart';

import '../../models/historical_service.dart';
import 'bloc/block_user_bloc.dart';
import 'components/block_user_confirmation_dialog.dart';
import 'components/body.dart';

class HistoricalServiceDetail extends StatefulWidget {
  final HistoricalService historicalService;
  const HistoricalServiceDetail({
    Key key,
    @required this.historicalService,
  }) : super(key: key);

  @override
  _HistoricalServiceDetailState createState() =>
      _HistoricalServiceDetailState();
}

class _HistoricalServiceDetailState extends State<HistoricalServiceDetail>
    with SingleTickerProviderStateMixin {
  PaymentDetail _paymentDetail;
  RateDetail _rateDetail;
  AsyncLoadingStatus _paymentDetailStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _rateDetailStatus = AsyncLoadingStatus.initial;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoadPaymentDetailBloc>(context).add(
        LoadPaymentDetail(serviceUuid: widget.historicalService.serviceUuid));

    BlocProvider.of<LoadRateDetailBloc>(context)
        .add(LoadRateDetail(serviceUuid: widget.historicalService.serviceUuid));
  }

  void _onRefreshRateDetail() {
    BlocProvider.of<LoadRateDetailBloc>(context)
        .add(LoadRateDetail(serviceUuid: widget.historicalService.serviceUuid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('交易'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoadPaymentDetailBloc, LoadPaymentDetailState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              setState(() {
                _paymentDetail = state.paymentDetail;
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
              _paymentDetailStatus = state.status;
            });
          }),
          BlocListener<LoadRateDetailBloc, LoadRateDetailState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              setState(() {
                _rateDetail = state.rateDetail;
              });
            }

            if (state.status == AsyncLoadingStatus.error) {
              developer.log(
                'failed to fetch rate detail or maybe no have rate yet',
                error: state.error,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error.message),
                ),
              );
            }

            setState(() {
              _rateDetailStatus = state.status;
            });
          }),
          BlocListener<BlockUserBloc, BlockUserState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('用戶已被封鎖'),
                ),
              );

              BlocProvider.of<LoadPaymentDetailBloc>(context).add(
                  LoadPaymentDetail(
                      serviceUuid: widget.historicalService.serviceUuid));
            }

            if (state.status == AsyncLoadingStatus.error) {
              developer.log(
                'failed to fetch rate detail or maybe no have rate yet',
                error: state.error,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error.message),
                ),
              );
            }
          }),
        ],
        child: Body(
          historicalService: widget.historicalService,
          paymentDetail: _paymentDetail,
          rateDetail: _rateDetail,
          paymentDetailStatus: _paymentDetailStatus,
          rateDetailStatus: _rateDetailStatus,
          onRefreshRateDetail: _onRefreshRateDetail,
          onRating: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SendRateBloc(
                        apiClient: ServiceChatroomClient(),
                      ),
                    ),
                  ],
                  child: Rate(
                    historicalService: widget.historicalService,
                  ),
                );
              },
            )).then((refresh) {
              if (refresh != null) {
                if (refresh == true) {
                  _onRefreshRateDetail();
                }
              }
            });
          },
          onBlock: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return BlockUserConfirmationDialog();
              },
            ).then((value) {
              if (value) {
                BlocProvider.of<BlockUserBloc>(context).add(BlockUser(
                    uuid: widget.historicalService.chatPartnerUserUuid));
              }
            });
          },
        ),
      ),
    );
  }
}
