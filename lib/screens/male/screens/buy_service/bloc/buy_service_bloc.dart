import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'buy_service_event.dart';
part 'buy_service_state.dart';

class BuyServiceBloc extends Bloc<BuyServiceEvent, BuyServiceState> {
  BuyServiceBloc({
    this.searchInquiryAPIs,
  })  : assert(searchInquiryAPIs != null),
        super(BuyServiceState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<BuyServiceState> mapEventToState(
    BuyServiceEvent event,
  ) async* {
    if (event is CreatePayment) {
      yield* _mapBuyServiceFormToState(event);
    }
  }

  Stream<BuyServiceState> _mapBuyServiceFormToState(
      CreatePayment event) async* {
    try {
      yield BuyServiceState.loading(state);

      final resp = await searchInquiryAPIs.buyService(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield BuyServiceState.done(state);
    } on APIException catch (e) {
      yield BuyServiceState.error(e);
    } catch (e) {
      yield BuyServiceState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
