import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  SendMessageBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(SendMessageState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<SendMessageState> mapEventToState(
    SendMessageEvent event,
  ) async* {
    if (event is SendMessageEvent) {
      yield* _mapSendMessageToState(event);
    }
  }

  Stream<SendMessageState> _mapSendMessageToState(
      SendMessageEvent event) async* {
    try {
      yield SendMessageState.loading();

      final resp = await inquiryChatroomApis.sendChatroomTextMessage(
        event.channelUUID,
        event.content,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield SendMessageState.loaded();
    } on APIException catch (e) {
      yield SendMessageState.loadFailed(e);
    } on Exception catch (e) {
      yield SendMessageState.loadFailed(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
