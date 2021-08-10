import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

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
    if (event is SendTextMessage) {
      yield* _mapSendMessageToState(event);
    }
    // else if (event is SendUpdateInquiryMessage) {
    //   yield* _mapSendUpdateInquiryMessage(event);
    // }
  }

  Stream<SendMessageState> _mapSendMessageToState(
      SendTextMessage event) async* {
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

  // Stream<SendMessageState> _mapSendUpdateInquiryMessage(
  //     SendUpdateInquiryMessage event) async* {
  //   yield SendMessageState.loading();

  //   final serviceSettings = event.serviceSettings;

  //   final resp = await inquiryChatroomApis.sendInquiryUpdateMessage(
  //     serviceUUID: event.serviceSettings.uuid,
  //     channelUUID: event.channelUUID,
  //     serviceTime: new DateTime(
  //       serviceSettings.serviceDate.year,
  //       serviceSettings.serviceDate.month,
  //       serviceSettings.serviceDate.day,
  //       serviceSettings.serviceTime.hour,
  //       serviceSettings.serviceTime.minute,
  //     ),
  //     serviceDuration: serviceSettings.duration.inMinutes,
  //     price: serviceSettings.price,
  //     serviceType: serviceSettings.serviceType,
  //     address: serviceSettings.address,
  //   );

  //   developer.log(
  //     'Service  detail message emitted ${resp.body}',
  //     time: DateTime.now(),
  //     name: 'service detail',
  //   );

  //   // yield SendMessageState.loaded();
  // }
}
