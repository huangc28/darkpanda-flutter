import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/payment_card.dart';

part 'buy_dp_event.dart';
part 'buy_dp_state.dart';

class BuyDpBloc extends Bloc<BuyDpEvent, BuyDpState> {
  BuyDpBloc({
    this.apiClient,
  }) : super(BuyDpState.initial());

  final TopUpClient apiClient;

  @override
  Stream<BuyDpState> mapEventToState(
    BuyDpEvent event,
  ) async* {
    if (event is BuyDp) {
      yield* _mapVerifyBankToState(event);
    }
  }

  Stream<BuyDpState> _mapVerifyBankToState(BuyDp event) async* {
    try {
      yield BuyDpState.loading();

      BuyCoin buyDp = event.buyCoin;

      final resp = await apiClient.buyDp(buyDp);

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield BuyDpState.done();
    } on APIException catch (e) {
      yield BuyDpState.error(e);
    } catch (e) {
      yield BuyDpState.error(new AppGeneralExeption(message: e.toString()));
    }
  }
}
