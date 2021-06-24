import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import '../../../services/service_chatroom_api.dart';
import 'package:darkpanda_flutter/screens/service_list/screens/rate/models/rating.dart';

part 'send_rate_event.dart';
part 'send_rate_state.dart';

class SendRateBloc extends Bloc<SendRateEvent, SendRateState> {
  SendRateBloc({
    this.apiClient,
  })  : assert(apiClient != null),
        super(SendRateState.initial());

  final ServiceChatroomClient apiClient;

  @override
  Stream<SendRateState> mapEventToState(
    SendRateEvent event,
  ) async* {
    if (event is SendRate) {
      yield* _mapSendRateToState(event);
    }
  }

  Stream<SendRateState> _mapSendRateToState(SendRate event) async* {
    try {
      yield SendRateState.loading();

      final resp = await apiClient.sendRate(event.rating);

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield SendRateState.done();
    } on APIException catch (e) {
      print('DEBUG err 1 ${e}');
      yield SendRateState.error(e);
    } catch (e) {
      yield SendRateState.error(new AppGeneralExeption(message: e.toString()));
    }
  }
}
