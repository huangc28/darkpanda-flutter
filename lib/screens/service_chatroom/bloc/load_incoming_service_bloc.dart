import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/models/incoming_service.dart';
import 'package:darkpanda_flutter/screens/service_chatroom/services/service_chatroom_api.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/message.dart';

// import '../services/apis.dart';

part 'load_incoming_service_event.dart';
part 'load_incoming_service_state.dart';

class LoadIncomingServiceBloc
    extends Bloc<LoadIncomingServiceEvent, LoadIncomingServiceState> {
  LoadIncomingServiceBloc({
    this.apiClient,
    this.inquiryChatMesssagesBloc,
    this.inquiryChatroomApis,
  }) : super(LoadIncomingServiceState.initial());

  final ServiceChatroomClient apiClient;
  Map<String, bool> _chatFirstCreateMap = {};

  final InquiryChatMessagesBloc inquiryChatMesssagesBloc;
  final InquiryChatroomApis inquiryChatroomApis;

  @override
  Stream<LoadIncomingServiceState> mapEventToState(
    LoadIncomingServiceEvent event,
  ) async* {
    if (event is LoadIncomingService) {
      yield* _mapLoadIncomingServiceEventToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is PutLatestMessage) {
      yield* _mapPutLatestMessage(event);
    } else if (event is ClearIncomingServiceState) {
      yield* _mapClearIncomingServiceStateToState(event);
    }
  }

  Stream<LoadIncomingServiceState> _mapLoadIncomingServiceEventToState(
      LoadIncomingService event) async* {
    try {
      // toggle loading
      yield LoadIncomingServiceState.loading(state);

      // request API
      final res = await apiClient.fetchIncomingService();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      // yield LoadIncomingServiceState.loaded(
      //   services: IncomingServiceList.fromJson(json.decode(res.body)),
      // );
      final Map<String, dynamic> respMap = json.decode(res.body);

      final serviceList = respMap['services'].map<IncomingService>((v) {
        return IncomingService.fromJson(v);
      }).toList();
      // final chatrooms = IncomingServiceList.fromJson(json.decode(res.body));

      add(
        AddChatrooms(serviceList),
      );
    } on APIException catch (err) {
      yield LoadIncomingServiceState.loadFailed(state, err);
    } catch (err) {
      yield LoadIncomingServiceState.loadFailed(
        state,
        AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadIncomingServiceState> _mapAddChatroomsToState(
      AddChatrooms event) async* {
    // Iterate through list of chatrooms. Skip channel subscription
    // if channel uuid exists in the current map.
    for (final chatroom in event.chatrooms) {
      if (state.privateChatStreamMap.containsKey(chatroom.channelUuid)) {
        continue;
      }

      // Channel uuid does not exists in map, initiate subscription stream.
      // Store the stream in `privateChatStreamMap`.
      final streamSub = _createChatroomSubscriptionStream(chatroom.channelUuid);

      // Put a flag to indicate that the channel has just been created. Ignore
      // the first event from firestore subscription.
      _chatFirstCreateMap[chatroom.channelUuid] = true;

      state.privateChatStreamMap[chatroom.channelUuid] = streamSub;

      // Insert new chatroom at the start of the chatroom array.
      state.services.insert(0, chatroom);
    }
    final newPrivateChatStreamMap = Map.of(state.privateChatStreamMap);

    yield LoadIncomingServiceState.updateChatrooms(
      state,
      services: [...event.chatrooms],
      privateChatStreamMap: newPrivateChatStreamMap,
    );

    for (final chatroom in event.chatrooms) {
      if (chatroom.messages.length > 0) {
        // Update latest message for each chatroom.
        add(
          PutLatestMessage(
            channelUUID: chatroom.channelUuid,
            message: chatroom.messages[0],
          ),
        );
      }
    }
  }

  StreamSubscription<QuerySnapshot> _createChatroomSubscriptionStream(
      String channelUUID) {
    return FirebaseFirestore.instance
        .collection('private_chats')
        .doc(channelUUID)
        .collection('messages')
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        // Ignore the first event sent from firestore when the subscription first
        // created. It messes up the displaying the latest message on the chatroom
        // list.
        if (_chatFirstCreateMap[channelUUID] == false) {
          _handlePrivateChatEvent(channelUUID, snapshot);
        }

        // Toggle the flag to `false` for the subsequent event to trigger the
        // handler `_handlePrivateChatEvent`.
        _chatFirstCreateMap[channelUUID] = false;
      },
    );
  }

  _handlePrivateChatEvent(String channelUUID, QuerySnapshot event) {
    developer.log('handle private chat on channel ID: $channelUUID');

    final message = Message.fromMap(
      event.docChanges.first.doc.data(),
    );

    developer.log('dispatching private chat message: ${message.content}');

    add(
      PutLatestMessage(
        channelUUID: channelUUID,
        message: message,
      ),
    );

    inquiryChatMesssagesBloc.add(
      DispatchMessage(
        chatroomUUID: channelUUID,
        message: message,
      ),
    );
  }

  Stream<LoadIncomingServiceState> _mapPutLatestMessage(
      PutLatestMessage event) async* {
    final newMap = Map.of(state.chatroomLastMessage);
    newMap[event.channelUUID] = event.message;

    yield LoadIncomingServiceState.putChatroomLatestMessage(
      state,
      chatroomLastMessage: newMap,
    );
  }

  Stream<LoadIncomingServiceState> _mapClearIncomingServiceStateToState(
      ClearIncomingServiceState event) async* {
    yield LoadIncomingServiceState.clearState(state);
  }
}