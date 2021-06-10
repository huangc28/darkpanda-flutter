import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/models/service_detail_message.dart';
import 'package:darkpanda_flutter/models/service_confirmed_message.dart';
import 'package:darkpanda_flutter/models/update_inquiry_message.dart';
import 'package:darkpanda_flutter/models/user_profile.dart';

import 'package:darkpanda_flutter/enums/message_types.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/models/disagree_inquiry_message.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/update_inquitry_notifier_bloc.dart';

part 'current_chatroom_event.dart';
part 'current_chatroom_state.dart';

class CurrentChatroomBloc
    extends Bloc<CurrentChatroomEvent, CurrentChatroomState> {
  CurrentChatroomBloc({
    this.inquiryChatroomApis,
    this.userApis,
    this.inquiryChatroomsBloc,
    this.currentServiceBloc,
    this.serviceConfirmNotifierBloc,
    this.updateInquiryNotifierBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(userApis != null),
        assert(inquiryChatroomsBloc != null),
        assert(currentServiceBloc != null),
        assert(serviceConfirmNotifierBloc != null),
        assert(updateInquiryNotifierBloc != null),
        super(CurrentChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final UserApis userApis;

  final InquiryChatroomsBloc inquiryChatroomsBloc;
  final CurrentServiceBloc currentServiceBloc;
  final ServiceConfirmNotifierBloc serviceConfirmNotifierBloc;
  final UpdateInquiryNotifierBloc updateInquiryNotifierBloc;

  @override
  Stream<CurrentChatroomState> mapEventToState(
    CurrentChatroomEvent event,
  ) async* {
    if (event is InitCurrentChatroom) {
      yield* _mapInitCurrentChatroomToState(event);
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

      yield CurrentChatroomState.loaded(
        state,
        historicalMessages: newMessages,
        page: state.page + 1,
      );
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
    try {
      // Fetch historical messages
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

      // Convert response data to list of messages and store them to historical messages.
      final historicalMessages = respMap['messages'].map<Message>((data) {
        if (data['type'] == MessageType.service_detail.name) {
          return ServiceDetailMessage.fromMap(data);
        } else if (data['type'] == MessageType.confirmed_service.name) {
          return ServiceConfirmedMessage.fromMap(data);
        } else if (data['type'] == MessageType.update_inquiry_detail.name) {
          return UpdateInquiryMessage.fromMap(data);
        } else if (data['type'] == MessageType.disagree_inquiry.name) {
          return DisagreeInquiryMessage.fromMap(data);
        } else {
          return Message.fromMap(data);
        }
      }).toList();

      // Fetch inquirer profile.
      final upResp = await userApis.fetchUser(event.inquirerUUID);

      final inquirerProfile = UserProfile.fromJson(
        json.decode(upResp.body),
      );

      // Grab chatroom subscription and listen to incoming messages. Push new message to
      // current message array.
      final subStream =
          inquiryChatroomsBloc.state.privateChatStreamMap[event.channelUUID];

      subStream.onData((data) {
        _handleCurrentMessage(data, event.channelUUID);
      });

      yield CurrentChatroomState.loaded(
        state,
        inquirerProfile: inquirerProfile,
        historicalMessages: historicalMessages,
      );
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

  _handleCurrentMessage(data, String channelUUID) {
    final QuerySnapshot msgSnapShot = data;
    final rawMsg = msgSnapShot.docChanges.first.doc.data() as Map;

    developer
        .log('Current chatroom incoming message ${rawMsg['type'].toString()}');

    final isServiceDetailMsg =
        (String type) => type == MessageType.service_detail.name;
    final isConfirmedServiceMsg =
        (String type) => type == MessageType.confirmed_service.name;
    final isUpdateInquiryDetailMsg =
        (String type) => type == MessageType.update_inquiry_detail.name;
    final isDisagreeInquiryMsg =
        (String type) => type == MessageType.disagree_inquiry.name;

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

      serviceConfirmNotifierBloc.add(NotifyServiceConfirmed(msg));
    } else if (isUpdateInquiryDetailMsg(rawMsg['type'])) {
      msg = UpdateInquiryMessage.fromMap(rawMsg);

      updateInquiryNotifierBloc.add(UpdateInquiryConfirmed(msg));
    } else if (isDisagreeInquiryMsg(rawMsg['type'])) {
      msg = DisagreeInquiryMessage.fromMap(rawMsg);
    } else {
      msg = Message.fromMap(rawMsg);
    }

    add(DispatchNewMessage(message: msg));
  }

  Stream<CurrentChatroomState> _mapLeaveCurrentChatroomToState(
      LeaveCurrentChatroom event) async* {
    // Reset current chatroom messages.
    // Reset current chatroom historical messages.
    // Reset page number.
    yield CurrentChatroomState.init();
  }
}
