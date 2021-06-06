import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/bloc/load_incoming_service_bloc.dart';

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

part 'current_service_chatroom_event.dart';
part 'current_service_chatroom_state.dart';

class CurrentServiceChatroomBloc
    extends Bloc<CurrentServiceChatroomEvent, CurrentServiceChatroomState> {
  CurrentServiceChatroomBloc({
    this.inquiryChatroomApis,
    this.userApis,
    this.loadIncomingServiceBloc,
    this.currentServiceBloc,
    this.serviceConfirmNotifierBloc,
  })  : assert(inquiryChatroomApis != null),
        assert(userApis != null),
        assert(loadIncomingServiceBloc != null),
        assert(currentServiceBloc != null),
        assert(serviceConfirmNotifierBloc != null),
        super(CurrentServiceChatroomState.init());

  final InquiryChatroomApis inquiryChatroomApis;
  final UserApis userApis;

  final LoadIncomingServiceBloc loadIncomingServiceBloc;
  final CurrentServiceBloc currentServiceBloc;
  final ServiceConfirmNotifierBloc serviceConfirmNotifierBloc;

  @override
  Stream<CurrentServiceChatroomState> mapEventToState(
    CurrentServiceChatroomEvent event,
  ) async* {
    if (event is InitCurrentServiceChatroom) {
      yield* _mapInitCurrentChatroomToState(event);
    } else if (event is DispatchNewMessage) {
      yield* _mapDispatchNewMessageToState(event);
    } else if (event is FetchMoreHistoricalMessages) {
      yield* _mapFetchMoreHistoricalMessagesToState(event);
    } else if (event is LeaveCurrentServiceChatroom) {
      yield* _mapLeaveCurrentChatroomToState(event);
    }
  }

  Stream<CurrentServiceChatroomState> _mapFetchMoreHistoricalMessagesToState(
      FetchMoreHistoricalMessages event) async* {
    try {
      await CurrentServiceChatroomState.loading(state);

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

      yield CurrentServiceChatroomState.loaded(
        state,
        historicalMessages: newMessages,
        page: state.page + 1,
      );
    } on APIException catch (e) {
      yield CurrentServiceChatroomState.loadFailed(state, e);
    } on Exception catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<CurrentServiceChatroomState> _mapDispatchNewMessageToState(
      DispatchNewMessage event) async* {
    final messages = List<Message>.from(state.currentMessages)
      ..insert(0, event.message);

    yield CurrentServiceChatroomState.updateCurrentMessage(
      state,
      messages,
    );
  }

  Stream<CurrentServiceChatroomState> _mapInitCurrentChatroomToState(
      InitCurrentServiceChatroom event) async* {
    try {
      // Fetch historical messages
      yield CurrentServiceChatroomState.loading(state);

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
          loadIncomingServiceBloc.state.privateChatStreamMap[event.channelUUID];

      subStream.onData((data) {
        _handleCurrentMessage(data, event.channelUUID);
      });

      yield CurrentServiceChatroomState.loaded(
        state,
        inquirerProfile: inquirerProfile,
        historicalMessages: historicalMessages,
      );
    } on APIException catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
        state,
        e,
      );
    } on Exception catch (e) {
      yield CurrentServiceChatroomState.loadFailed(
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
    } else {
      msg = Message.fromMap(rawMsg);
    }

    add(DispatchNewMessage(message: msg));
  }

  Stream<CurrentServiceChatroomState> _mapLeaveCurrentChatroomToState(
      LeaveCurrentServiceChatroom event) async* {
    // Reset current chatroom messages.
    // Reset current chatroom historical messages.
    // Reset page number.
    yield CurrentServiceChatroomState.init();
  }
}