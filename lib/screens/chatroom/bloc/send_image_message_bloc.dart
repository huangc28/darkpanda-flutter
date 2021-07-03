import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'send_image_message_event.dart';
part 'send_image_message_state.dart';

class SendImageMessageBloc
    extends Bloc<SendImageMessageEvent, SendImageMessageState> {
  SendImageMessageBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(SendImageMessageState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<SendImageMessageState> mapEventToState(
    SendImageMessageEvent event,
  ) async* {
    if (event is SendImageMessage) {
      yield* _mapSendImageMessageToState(event);
    }
  }

  Stream<SendImageMessageState> _mapSendImageMessageToState(
      SendImageMessage event) async* {
    try {
      yield SendImageMessageState.loading();

      final resp = await inquiryChatroomApis.sendChatroomImageMessage(
        event.channelUUID,
        event.imageUrl,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield SendImageMessageState.loaded();
    } on APIException catch (e) {
      yield SendImageMessageState.loadFailed(e);
    } on Exception catch (e) {
      yield SendImageMessageState.loadFailed(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
