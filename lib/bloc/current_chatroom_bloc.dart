import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/enums/message_types.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/current_service_bloc.dart';

part 'current_chatroom_event.dart';
part 'current_chatroom_state.dart';

class CurrentChatroomBloc
    extends Bloc<CurrentChatroomEvent, CurrentChatroomState> {
  CurrentChatroomBloc({
    this.inquiryChatroomApis,
    this.inquiryChatroomsBloc,
    this.currentServiceBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(inquiryChatroomsBloc != null),
        assert(currentServiceBloc != null),
        super(CurrentChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final InquiryChatroomsBloc inquiryChatroomsBloc;
  final CurrentServiceBloc currentServiceBloc;

  @override
  Stream<CurrentChatroomState> mapEventToState(
    CurrentChatroomEvent event,
  ) async* {
    if (event is InitCurrentChatroom) {
      yield* _mapInitCurrentChatroomToState(event);
    } else if (event is FetchHistoricalMessages) {
      yield* _mapFetchHistoricalMessagesToState(event);
    } else if (event is DispatchNewMessage) {
      yield* _mapDispatchNewMessageToState(event);
    } else if (event is FetchMoreHistoricalMessages) {
      yield* _mapFetchMoreHistoricalMessagesToState(event);
    } else if (event is LeaveCurrentChatroom) {
      yield* _mapLeaveCurrentChatroomToState(event);
    }
  }

  Stream<CurrentChatroomState> _mapFetchMoreHistoricalMessagesToState(
      FetchMoreHistoricalMessages event) async* {
    try {
      await CurrentChatroomState.loading(state);

      // Fetching historical messages.
      final resp = await inquiryChatroomApis.fetchInquiryHistoricalMessages(
        event.channelUUID,
        event.perPage,
        state.page + 1,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);

      final prevPageMessage = respMap['messages']
          .map<Message>((data) => Message.fromMap(data))
          .toList();

      final newMessages = List<Message>.from(state.historicalMessages)
        ..addAll(prevPageMessage);

      yield CurrentChatroomState.loaded(state, newMessages, state.page + 1);
    } on APIException catch (e) {
      yield CurrentChatroomState.loadFailed(state, e);
    } on Exception catch (e) {
      yield CurrentChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
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

    subStream.onData((data) => _handleCurrentMessage(data, event.channelUUID));
  }

  _handleCurrentMessage(data, String channelUUID) {
    final QuerySnapshot msgSnapShot = data;
    final rawMsg = msgSnapShot.docChanges.first.doc.data();

    developer.log('Current chatroom incoming message ${rawMsg}');

    final isServiceDetailMsg =
        (String type) => type == MessageType.service_detail.name;
    final isConfirmedServiceMsg =
        (String type) => type == MessageType.confirmed_service.name;
    final isUpdateInquiryDetailMsg =
        (String type) => type == MessageType.update_inquiry_detail.name;

    // Transform to different message object according to type.
    // Dispatch new message to current chat message array.
    Message msg;

    if (isServiceDetailMsg(rawMsg['type'])) {
      msg = ServiceDetailMessage.fromMap(rawMsg);

      currentServiceBloc.add(
        UpdateCurrentServiceByMessage(
          messasge: msg,
        ),
      );
    } else if (isConfirmedServiceMsg(rawMsg['type'])) {
      msg = ServiceConfirmedMessage.fromMap(rawMsg);
    } else if (isUpdateInquiryDetailMsg(rawMsg['type'])) {
      msg = UpdateInquiryMessage.fromMap(rawMsg);
    } else {
      msg = Message.fromMap(rawMsg);
    }

    add(DispatchNewMessage(message: msg));
  }

  Stream<CurrentChatroomState> _mapFetchHistoricalMessagesToState(
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

      // Convert response data to list of messages and store them to historical messages.
      final Map<String, dynamic> respMap = json.decode(resp.body);

      if (respMap['messages'].isEmpty) {
        return;
      }

      final historicalMessages = respMap['messages'].map<Message>((data) {
        if (data['type'] == MessageType.service_detail.name) {
          return ServiceDetailMessage.fromMap(data);
        } else if (data['type'] == MessageType.confirmed_service.name) {
          return ServiceConfirmedMessage.fromMap(data);
        } else if (data['type'] == MessageType.update_inquiry_detail.name) {
          return UpdateInquiryMessage.fromMap(data);
        } else {
          return Message.fromMap(data);
        }
      }).toList();

      yield CurrentChatroomState.loaded(state, historicalMessages, state.page);
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

  Stream<CurrentChatroomState> _mapLeaveCurrentChatroomToState(
      LeaveCurrentChatroom event) async* {
    // Reset current chatroom messages.
    // Reset current chatroom historical messages.
    // Reset page number.
    yield CurrentChatroomState.init();
  }
}
