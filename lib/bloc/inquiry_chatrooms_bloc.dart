import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../models/chatroom.dart';

part 'inquiry_chatrooms_event.dart';
part 'inquiry_chatrooms_state.dart';

class InquiryChatroomsBloc
    extends Bloc<InquiryChatroomsEvent, InquiryChatroomsState> {
  InquiryChatroomsBloc({
    this.inquiryChatMesssagesBloc,
    this.inquiryChatroomApis,
  })  : assert(inquiryChatMesssagesBloc != null),
        assert(inquiryChatroomApis != null),
        super(InquiryChatroomsState.init());

  final InquiryChatMessagesBloc inquiryChatMesssagesBloc;
  final InquiryChatroomApis inquiryChatroomApis;

  /// We found that we will receive an initial event message we subscribe to firestore document.
  /// This message is the first message in the chatroom and would override the latest message
  /// we retrieved from the backend. It causes the chatroom list to display the first message instead
  /// of the latest message. `_chatFirstCreateMap` keeps track of initial creation of the scription.
  /// If a given channel has just created, we ignore the first event if the value is `true`. It then
  /// toggle the value to `false`. Any subsequent event would trigger the message handler.
  Map<String, bool> _chatFirstCreateMap = {};

  @override
  Stream<InquiryChatroomsState> mapEventToState(
    InquiryChatroomsEvent event,
  ) async* {
    if (event is LeaveChatroom) {
      yield* _mapLeaveChatroomToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is FetchChatrooms) {
      yield* _mapFetchChatroomToState(event);
    } else if (event is PutLatestMessage) {
      yield* _mapPutLatestMessage(event);
    } else if (event is ClearInquiryChatList) {
      yield* _mapClearInquiryChatListToState(event);
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

  Stream<InquiryChatroomsState> _mapAddChatroomsToState(
      AddChatrooms event) async* {
    // Iterate through list of chatrooms. Skip channel subscription
    // if channel uuid exists in the current map.
    for (final chatroom in event.chatrooms) {
      if (state.privateChatStreamMap.containsKey(chatroom.channelUUID)) {
        continue;
      }

      // Channel uuid does not exists in map, initiate subscription stream.
      // Store the stream in `privateChatStreamMap`.
      final streamSub = _createChatroomSubscriptionStream(chatroom.channelUUID);

      // Put a flag to indicate that the channel has just been created. Ignore
      // the first event from firestore subscription.
      _chatFirstCreateMap[chatroom.channelUUID] = true;

      state.privateChatStreamMap[chatroom.channelUUID] = streamSub;

      // Insert new chatroom at the start of the chatroom array.
      state.chatrooms.insert(0, chatroom);
    }
    final newPrivateChatStreamMap = Map.of(state.privateChatStreamMap);

    yield InquiryChatroomsState.updateChatrooms(
      state,
      chatrooms: [...event.chatrooms],
      privateChatStreamMap: newPrivateChatStreamMap,
    );

    for (final chatroom in event.chatrooms) {
      if (chatroom.messages.length > 0) {
        // Update latest message for each chatroom.
        add(
          PutLatestMessage(
            channelUUID: chatroom.channelUUID,
            message: chatroom.messages[0],
          ),
        );
      }
    }
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

  Stream<InquiryChatroomsState> _mapLeaveChatroomToState(
      LeaveChatroom event) async* {
    // Unsubscribe specified private chat stream.
    if (state.privateChatStreamMap.containsKey(event.channelUUID)) {
      final stream = state.privateChatStreamMap[event.channelUUID];

      stream.cancel();

      state.privateChatStreamMap.remove(event.channelUUID);

      state.chatrooms
          .where((chatroom) => chatroom.channelUUID != event.channelUUID)
          .toList();

      yield InquiryChatroomsState.updateChatrooms(state);

      // Remove chatroom in the app alone with it's messages.
      inquiryChatMesssagesBloc.add(
        RemovePrivateChatRoom(chatroomUUID: event.channelUUID),
      );
    } else {
      developer.log(
        'Stream intends to unsubscribe is\'t exist for the given  channel UUID',
        name: 'private_chat:unsubscribe_stream',
      );
    }

    yield null;
  }

  Stream<InquiryChatroomsState> _mapFetchChatroomToState(
      FetchChatrooms event) async* {
    try {
      yield InquiryChatroomsState.loading(state);
      final resp = await inquiryChatroomApis.fetchInquiryChatrooms();

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);

      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      add(
        AddChatrooms(chatrooms),
      );
    } on APIException catch (err) {
      developer.log(
        err.toString(),
        name: "APIException: fetch_chats_bloc",
      );

      yield InquiryChatroomsState.loadFailed(state, err);
    } on AppGeneralExeption catch (e) {
      developer.log(
        e.toString(),
        name: "AppGeneralExeption: fetch_chats_bloc",
      );

      yield InquiryChatroomsState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<InquiryChatroomsState> _mapPutLatestMessage(
      PutLatestMessage event) async* {
    final newMap = Map.of(state.chatroomLastMessage);
    newMap[event.channelUUID] = event.message;

    yield InquiryChatroomsState.putChatroomLatestMessage(
      state,
      chatroomLastMessage: newMap,
    );
  }

  Stream<InquiryChatroomsState> _mapClearInquiryChatListToState(
      ClearInquiryChatList event) async* {
    yield InquiryChatroomsState.clearInqiuryChatList(state);
  }
}
