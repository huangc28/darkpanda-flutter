import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/screens/service_list/models/payment_detail.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import '../../../services/service_chatroom_api.dart';
import 'package:darkpanda_flutter/screens/service_list/models/rate_detail.dart';

part 'load_payment_detail_event.dart';
part 'load_payment_detail_state.dart';

class LoadPaymentDetailBloc
    extends Bloc<LoadPaymentDetailEvent, LoadPaymentDetailState> {
  LoadPaymentDetailBloc({
    this.apiClient,
  }) : super(LoadPaymentDetailState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<LoadPaymentDetailState> mapEventToState(
    LoadPaymentDetailEvent event,
  ) async* {
    if (event is LoadPaymentDetail) {
      yield* _mapLoadPaymentDetailEventToState(event);
    }
  }

  Stream<LoadPaymentDetailState> _mapLoadPaymentDetailEventToState(
      LoadPaymentDetail event) async* {
    try {
      // toggle loading
      yield LoadPaymentDetailState.loading(state);

      // request API
      final res = await apiClient.fetchPaymentDetail(event.serviceUuid);

      print(json.decode(res.body));

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadPaymentDetailState.loadSuccess(state,
          paymentDetail: PaymentDetail.fromJson(
            json.decode(res.body),
          ));
    } on APIException catch (err) {
      print(err);
      yield LoadPaymentDetailState.loadFailed(state, err);
    } catch (err) {
      print(err);
      yield LoadPaymentDetailState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
