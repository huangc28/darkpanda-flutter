import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/load_cancel_service_bloc.dart';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/historical_service_detail/bloc/load_payment_detail_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/cancel_service_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/models/historical_service.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/models/service_details.dart';

import 'components/body.dart';
import '../components/service_alert_dialog.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({
    Key key,
    @required this.historicalService,
    this.serviceDetails,
  }) : super(key: key);

  final HistoricalService historicalService;
  final ServiceDetails serviceDetails;

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail>
    with SingleTickerProviderStateMixin {
  PaymentDetail _paymentDetail;
  AsyncLoadingStatus _paymentDetailStatus = AsyncLoadingStatus.initial;
  AsyncLoadingStatus _cancelServiceStatus = AsyncLoadingStatus.initial;

  String _gender;
  String _cancelCause = '';

  @override
  void initState() {
    super.initState();

    _getGender().then((value) {
      _gender = value;
    });

    BlocProvider.of<LoadPaymentDetailBloc>(context).add(
        LoadPaymentDetail(serviceUuid: widget.historicalService.serviceUuid));
  }

  Future<String> _getGender() async {
    return await SecureStore().readGender();
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
        leading: IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
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
          BlocListener<CancelServiceBloc, CancelServiceState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {}

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
          BlocListener<LoadCancelServiceBloc, LoadCancelServiceState>(
              listener: (context, state) {
            if (state.status == AsyncLoadingStatus.done) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ServiceAlertDialog(
                      confirmText: AppLocalizations.of(context).confirmCancel,
                      cancelText: AppLocalizations.of(context).dontCancel,
                      content: '對方將可以給你評價，確定取消?',
                      onConfirm: () async {
                        Navigator.pop(context, true);
                      },
                      onDismiss: () async {
                        Navigator.pop(context, false);
                      });
                },
              ).then((value) {
                if (value) {
                  BlocProvider.of<CancelServiceBloc>(context).add(
                    CancelService(
                        serviceUuid: widget.historicalService.serviceUuid),
                  );
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
          historicalService: widget.historicalService,
          paymentDetail: _paymentDetail,
          serviceDetails: widget.serviceDetails,
          paymentDetailStatus: _paymentDetailStatus,
          cancelServiceStatus: _cancelServiceStatus,
          onCancelService: () {
            BlocProvider.of<LoadCancelServiceBloc>(context).add(
              LoadCancelService(
                  serviceUuid: widget.historicalService.serviceUuid),
            );
          },
        ),
      ),
    );
  }
}
