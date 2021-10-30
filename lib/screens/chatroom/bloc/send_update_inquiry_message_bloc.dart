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

part 'send_update_inquiry_message_event.dart';
part 'send_update_inquiry_message_state.dart';

class SendUpdateInquiryMessageBloc
    extends Bloc<SendUpdateInquiryMessageEvent, SendUpdateInquiryMessageState> {
  SendUpdateInquiryMessageBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(SendUpdateInquiryMessageState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<SendUpdateInquiryMessageState> mapEventToState(
    SendUpdateInquiryMessageEvent event,
  ) async* {
    if (event is SendUpdateInquiryMessage) {
      yield* _mapSendUpdateInquiryMessage(event);
    }
  }

  Stream<SendUpdateInquiryMessageState> _mapSendUpdateInquiryMessage(
      SendUpdateInquiryMessage event) async* {
    yield SendUpdateInquiryMessageState.loading();

    final serviceSettings = event.serviceSettings;

    final resp = await inquiryChatroomApis.sendInquiryUpdateMessage(
      serviceUUID: event.serviceSettings.uuid,
      channelUUID: event.channelUUID,
      serviceTime: new DateTime(
        serviceSettings.serviceDate.year,
        serviceSettings.serviceDate.month,
        serviceSettings.serviceDate.day,
        serviceSettings.serviceTime.hour,
        serviceSettings.serviceTime.minute,
      ),
      serviceDuration: serviceSettings.duration.inMinutes,
      price: serviceSettings.price,
      serviceType: serviceSettings.serviceType,
      address: serviceSettings.address,
    );

    developer.log(
      'Service detail message emitted ${resp.body}',
      time: DateTime.now(),
      name: 'service detail',
    );

    yield SendUpdateInquiryMessageState.loaded();
  }
}
