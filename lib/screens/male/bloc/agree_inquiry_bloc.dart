import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';
import 'package:darkpanda_flutter/screens/male/models/agree_inquiry_response.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'agree_inquiry_event.dart';
part 'agree_inquiry_state.dart';

class AgreeInquiryBloc extends Bloc<AgreeInquiryEvent, AgreeInquiryState> {
  AgreeInquiryBloc({
    this.inquiryChatroomsBloc,
    this.searchInquiryAPIs,
  })  : assert(searchInquiryAPIs != null),
        assert(inquiryChatroomsBloc != null),
        super(AgreeInquiryState.initial());

  final InquiryChatroomsBloc inquiryChatroomsBloc;
  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<AgreeInquiryState> mapEventToState(
    AgreeInquiryEvent event,
  ) async* {
    if (event is AgreeInquiry) {
      yield* _mapAgreeInquiryFormToState(event);
    }
  }

  Stream<AgreeInquiryState> _mapAgreeInquiryFormToState(
      AgreeInquiry event) async* {
    try {
      yield AgreeInquiryState.loading(state);

      final resp =
          await searchInquiryAPIs.agreeToChatInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      final AgreeInquiryResponse agreeInquiry = AgreeInquiryResponse.fromMap(
        json.decode(resp.body),
      );

      await inquiryChatroomsBloc.add(
        AddChatroom(
          chatroom: Chatroom(
            serviceType: agreeInquiry.serviceType,
            inquiryStatus: agreeInquiry.inquiryStatus,
            inquirerUUID: agreeInquiry.inquirer.uuid,
            username: agreeInquiry.picker.username,
            avatarURL: agreeInquiry.picker.avatarUrl,
            channelUUID: agreeInquiry.channelUuid,
          ),
        ),
      );

      yield AgreeInquiryState.done(
        state,
        agreeInquiry: agreeInquiry,
      );
    } on APIException catch (e) {
      yield AgreeInquiryState.error(e);
    } catch (e) {
      yield AgreeInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
