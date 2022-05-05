import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/models/chatroom.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/util/util.dart';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show InquiryChatMessagesBloc, DispatchMessage;

part 'load_direct_inquiry_chatrooms_event.dart';
part 'load_direct_inquiry_chatrooms_state.dart';

class LoadDirectInquiryChatroomsBloc extends Bloc<
    LoadDirectInquiryChatroomsEvent, LoadDirectInquiryChatroomsState> {
  LoadDirectInquiryChatroomsBloc({
    this.inquiryChatMesssagesBloc,
    this.searchInquiryAPIs,
  })  : assert(inquiryChatMesssagesBloc != null),
        assert(searchInquiryAPIs != null),
        super(LoadDirectInquiryChatroomsState.init());

  final InquiryChatMessagesBloc inquiryChatMesssagesBloc;
  final SearchInquiryAPIs searchInquiryAPIs;

  /// The app would receive a message from the subscription to the firestore document.
  /// This message would override the latest message we retrieved from the backend.
  /// It causes the chatroom list to display the first message instead
  /// of the latest message. `_chatFirstCreateMap` keeps track of initial creation of the scription.
  /// If a given channel has just created, we ignore the first event if the value is `true`. It then
  /// toggle the value to `false`. Any subsequent event would trigger the message handler.
  Map<String, bool> _chatFirstCreateMap = {};

  @override
  Stream<LoadDirectInquiryChatroomsState> mapEventToState(
    LoadDirectInquiryChatroomsEvent event,
  ) async* {
    if (event is FetchDirectInquiryChatrooms) {
      yield* _mapFetchDirectInquiryChatroomToState(event);
    } else if (event is LoadMoreChatrooms) {
      yield* _mapLoadMoreChatroomsToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is PutLatestMessage) {
      yield* _mapPutLatestMessage(event);
    } else if (event is ClearDirectInquiryChatList) {
      yield* _mapClearDirectInquiryChatListToState(event);
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
        // Ignore the first event sent from firestore when the subscription is first
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

  Stream<LoadDirectInquiryChatroomsState> _mapAddChatroomsToState(
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

    yield LoadDirectInquiryChatroomsState.updateChatrooms(
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

  Stream<LoadDirectInquiryChatroomsState> _mapFetchDirectInquiryChatroomToState(
      FetchDirectInquiryChatrooms event) async* {
    try {
      yield LoadDirectInquiryChatroomsState.loading(state);
      yield LoadDirectInquiryChatroomsState.clearInqiuryChatList(state);

      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await searchInquiryAPIs.fetchDirectInquiryChatrooms(
        offset: offset,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final Map<String, dynamic> respMap = jsonDecode(resp.body);

      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      add(AddChatrooms(chatrooms));
    } on APIException catch (err) {
      developer.log(
        err.toString(),
        name: "APIException: fetch_chats_bloc",
      );

      yield LoadDirectInquiryChatroomsState.loadFailed(state, err);
    } catch (e) {
      developer.log(
        e.toString(),
        name: "AppGeneralExeption: fetch_chats_bloc",
      );

      yield LoadDirectInquiryChatroomsState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<LoadDirectInquiryChatroomsState> _mapLoadMoreChatroomsToState(
      LoadMoreChatrooms event) async* {
    try {
      final offset = calcNextPageOffset(
        nextPage: state.currentPage + 1,
        perPage: event.perPage,
      );

      final resp = await searchInquiryAPIs.fetchDirectInquiryChatrooms(
        offset: offset,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final Map<String, dynamic> respMap = json.decode(resp.body);

      final chatrooms = respMap['chats']
          .map<Chatroom>((chat) => Chatroom.fromMap(chat))
          .toList();

      final appended = <Chatroom>[
        ...state.chatrooms,
        ...?chatrooms,
      ].toList();

      add(
        AddChatrooms(appended),
      );
    } on APIException catch (err) {
      developer.log(
        err.toString(),
        name: "APIException: fetch_chats_bloc",
      );

      yield LoadDirectInquiryChatroomsState.loadFailed(state, err);
    } on AppGeneralExeption catch (e) {
      developer.log(
        e.toString(),
        name: "AppGeneralExeption: fetch_chats_bloc",
      );

      yield LoadDirectInquiryChatroomsState.loadFailed(
        state,
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<LoadDirectInquiryChatroomsState> _mapPutLatestMessage(
      PutLatestMessage event) async* {
    final newMap = Map.of(state.chatroomLastMessage);
    newMap[event.channelUUID] = event.message;

    yield LoadDirectInquiryChatroomsState.putChatroomLatestMessage(
      state,
      chatroomLastMessage: newMap,
    );
  }

  Stream<LoadDirectInquiryChatroomsState> _mapClearDirectInquiryChatListToState(
      ClearDirectInquiryChatList event) async* {
    yield LoadDirectInquiryChatroomsState.clearInqiuryChatList(state);
  }
}
