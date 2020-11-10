import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';

part 'current_chatroom_event.dart';
part 'current_chatroom_state.dart';

class CurrentChatroomBloc
    extends Bloc<CurrentChatroomEvent, CurrentChatroomState> {
  CurrentChatroomBloc({
    this.inquiryChatroomApis,
    this.inquiryChatroomsBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(inquiryChatroomsBloc != null),
        super(CurrentChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final InquiryChatroomsBloc inquiryChatroomsBloc;

  @override
  Stream<CurrentChatroomState> mapEventToState(
    CurrentChatroomEvent event,
  ) async* {
    if (event is InitCurrentChatroom) {
      yield* _mapInitCurrentChatroomToState(event);
    } else if (event is FetchHistoricalMessages) {
      yield* _mapFetchHistoricalMessages(event);
    } else if (event is DispatchNewMessage) {
      yield* _mapDispatchNewMessageToState(event);
    }
  }

  Stream<CurrentChatroomState> _mapDispatchNewMessageToState(
      DispatchNewMessage event) async* {
    final messages = List<Message>.from(state.currentMessages)
      ..insert(0, event.message);

    yield CurrentChatroomState.updateCurrentMessage(
      state,
      messages,
    );
  }

  Stream<CurrentChatroomState> _mapInitCurrentChatroomToState(
      InitCurrentChatroom event) async* {
    // Fetch historical messages
    add(FetchHistoricalMessages(channelUUID: event.channelUUID));

    // Grab chatroom subscription and listen to incoming messages. Push new message to
    // current message array.
    final subStream =
        inquiryChatroomsBloc.state.privateChatStreamMap[event.channelUUID];

    subStream.onData(_handleCurrentMessage);
  }

  _handleCurrentMessage(data) {
    final QuerySnapshot msgSnapShot = data;
    final msg = Message.fromMap(
      msgSnapShot.docChanges.first.doc.data(),
    );

    // Dispatch new message to current chat array
    add(
      DispatchNewMessage(
        message: msg,
      ),
    );
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
      final Map<String, dynamic> respMap = json.decode(resp.body);

      if (respMap['messages'].isEmpty) {
        return;
      }

      final historicalMessages = respMap['messages']
          .map<Message>((data) => Message.fromMap(data))
          .toList();

      yield CurrentChatroomState.loaded(state, historicalMessages);
    } on APIException catch (e) {
      yield CurrentChatroomState.loadFailed(
        state,
        e,
      );
    } on Exception catch (e) {
      yield CurrentChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
