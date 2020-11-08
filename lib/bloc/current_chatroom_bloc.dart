import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom.dart';
import 'package:darkpanda_flutter/models/message.dart';

part 'current_chatroom_event.dart';
part 'current_chatroom_state.dart';

class CurrentChatroomBloc
    extends Bloc<CurrentChatroomEvent, CurrentChatroomState> {
  CurrentChatroomBloc({
    this.inquiryChatroomApis,
  })  : assert(inquiryChatroomApis != null),
        super(CurrentChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<CurrentChatroomState> mapEventToState(
    CurrentChatroomEvent event,
  ) async* {
    if (event is FetchHistoricalMessages) {
      yield* _mapFetchHistoricalMessages(event);
    }
  }

  Stream<CurrentChatroomState> _mapFetchHistoricalMessages(
      FetchHistoricalMessages event) async* {
    try {
      // Toggle loading state
      yield CurrentChatroomState.loading(state);

      final resp = await inquiryChatroomApis
          .fetchInquiryHistoricalMessages(event.channelUUID);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Convert response data to list of messages and store them to
      // historical messages.
      // {"messages":[{"content":"Welcome! %s has picked up your inquiry.","from":"f5045f5d-1727-4f97-a97e-7e62e080a198","to":"31a6b0dc-2857-4bad-b18e-76caab794dee","created_at":"2020-11-04T15:09:20.767463Z"}]}
      final Map<String, dynamic> respMap = json.decode(resp.body);

      if (respMap['messages'].isEmpty) {
        return;
      }

      final historicalMessages = respMap['messages']
          .map<Message>((data) => Message.fromMap(data))
          .toList();

      print('DEBUG spot 2 ${historicalMessages[0].content}');

      yield CurrentChatroomState.loaded(historicalMessages);
    } on APIException catch (e) {
      print('DEBUG spot 1 ${e.message}');
      yield CurrentChatroomState.loadFailed(
        state,
        e,
      );
    } on Exception catch (e) {
      print('DEBUG spot 2 ${e.toString()}');
      yield CurrentChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
