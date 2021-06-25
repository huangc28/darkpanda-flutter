import 'package:darkpanda_flutter/screens/service_list/models/historical_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'components/body.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_payment_detail_bloc.dart';

class ServiceDetail extends StatefulWidget {
  final HistoricalService historicalService;
  const ServiceDetail({
    Key key,
    @required this.historicalService,
  }) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail>
    with SingleTickerProviderStateMixin {
  PaymentDetail _paymentDetail;
  AsyncLoadingStatus _paymentDetailStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoadPaymentDetailBloc>(context).add(
        LoadPaymentDetail(serviceUuid: widget.historicalService.serviceUuid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        title: Text('交易'),
        centerTitle: true,
        actions: [
          Align(
            child: GestureDetector(
              onTap: () {
                print('幫助');
              },
              child: Text(
                '幫助',
                style: TextStyle(
                  color: Color.fromRGBO(106, 109, 137, 1),
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
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
        ],
        child: Body(
          historicalService: widget.historicalService,
          paymentDetail: _paymentDetail,
          paymentDetailStatus: _paymentDetailStatus,
        ),
      ),
    );
  }
}
