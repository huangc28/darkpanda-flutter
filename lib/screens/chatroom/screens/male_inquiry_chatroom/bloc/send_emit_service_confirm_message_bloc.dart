import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../models/emit_service_confirm_message_response.dart';

part 'send_emit_service_confirm_message_event.dart';
part 'send_emit_service_confirm_message_state.dart';

class SendEmitServiceConfirmMessageBloc extends Bloc<
    SendEmitServiceConfirmMessageEvent, SendEmitServiceConfirmMessageState> {
  SendEmitServiceConfirmMessageBloc({
    this.searchInquiryAPIs,
  }) : super(SendEmitServiceConfirmMessageState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<SendEmitServiceConfirmMessageState> mapEventToState(
    SendEmitServiceConfirmMessageEvent event,
  ) async* {
    if (event is EmitServiceConfirmMessage) {
      yield* _mapEmitServiceConfirmMessageFormToState(event);
    }
  }

  Stream<SendEmitServiceConfirmMessageState>
      _mapEmitServiceConfirmMessageFormToState(
          EmitServiceConfirmMessage event) async* {
    try {
      yield SendEmitServiceConfirmMessageState.loading(state);

      final resp = await searchInquiryAPIs
          .emitServiceComfirmedMessage(event.serviceUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      final emitServiceConfirmMessageResponse =
          EmitServiceConfirmMessageResponse.fromMap(json.decode(resp.body));

      yield SendEmitServiceConfirmMessageState.done(
        state,
        emitServiceConfirmMessageResponse: emitServiceConfirmMessageResponse,
      );
    } on APIException catch (e) {
      yield SendEmitServiceConfirmMessageState.error(e);
    } catch (e) {
      yield SendEmitServiceConfirmMessageState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
