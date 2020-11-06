import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom.dart';

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

  @override
  Stream<InquiryChatroomsState> mapEventToState(
    InquiryChatroomsEvent event,
  ) async* {
    if (event is LeaveChatroom) {
      yield* _mapLeaveChatroomToState(event);
    } else if (event is AddChatroom) {
      yield* _mapAddChatroomToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is FetchChatrooms) {
      yield* _mapFetchChatroomToState(event);
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
          (QuerySnapshot snapshot) =>
              _handlePrivateChatEvent(channelUUID, snapshot),
        );
  }

  Stream<InquiryChatroomsState> _mapAddChatroomToState(
      AddChatroom event) async* {
    try {
      // Test the adding a sample user to collection in firestore
      final streamSub =
          _createChatroomSubscriptionStream(event.chatroom.channelUUID);

      // Store stream to later cancel the subscription
      state.privateChatStreamMap[event.chatroom.channelUUID] = streamSub;

      yield InquiryChatroomsState.updateChatrooms(state);
    } catch (err) {
      yield InquiryChatroomsState.loadFailed(
        state,
        AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
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
      state.privateChatStreamMap[chatroom.channelUUID] = streamSub;

      // Insert new chatroom at the start of the chatroom array.
      state.chatrooms.insert(0, chatroom);
    }

    yield InquiryChatroomsState.updateChatrooms(state);

    for (final chatroom in event.chatrooms) {
      inquiryChatMesssagesBloc.add(
        DispatchMessage(
          chatroomUUID: chatroom.channelUUID,
          message: chatroom.latestMessage,
        ),
      );
    }
  }

  _handlePrivateChatEvent(String channelUUID, QuerySnapshot event) {
    developer.log('handle private chat on channel ID: $channelUUID');

    inquiryChatMesssagesBloc.add(
      DispatchMessage(
        chatroomUUID: channelUUID,
        message: Message.fromMap(event.docChanges.first.doc.data()),
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

      if (respMap['chats'].isEmpty) {
        return;
      }

      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      add(AddChatrooms(chatrooms));
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
}
