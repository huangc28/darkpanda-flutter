import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/util/util.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/contracts/chatroom.dart'
    show DispatchMessage, RemovePrivateChatRoom, InquiryChatMessagesBloc;

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

  /// The app would receive a message from the subscription to the firestore document.
  /// This message would override the latest message we retrieved from the backend.
  /// It causes the chatroom list to display the first message instead
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
    } else if (event is AddChatroom) {
      yield* _mapAddChatroomToState(event);
    } else if (event is AddChatrooms) {
      yield* _mapAddChatroomsToState(event);
    } else if (event is FetchChatrooms) {
      yield* _mapFetchChatroomToState(event);
    } else if (event is LoadMoreChatrooms) {
      yield* _mapLoadMoreChatroomsToState(event);
    } else if (event is PutLatestMessage) {
      yield* _mapPutLatestMessage(event);
    } else if (event is ClearInquiryChatList) {
      yield* _mapClearInquiryChatListToState(event);
    } else if (event is ClearInquiryList) {
      yield* _mapClearInquiryListToState(event);
    } else if (event is LeaveMaleChatroom) {
      yield* _mapLeaveMaleChatroomToState(event);
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

  Stream<InquiryChatroomsState> _mapAddChatroomToState(
      AddChatroom event) async* {
    // If channel uuid exists in the current map.
    // Channel uuid does not exists in map, initiate subscription stream.
    // Store the stream in `privateChatStreamMap`.
    final streamSub =
        _createChatroomSubscriptionStream(event.chatroom.channelUUID);

    // Put a flag to indicate that the channel has just been created. Ignore
    // the first event from firestore subscription.
    _chatFirstCreateMap[event.chatroom.channelUUID] = true;

    state.privateChatStreamMap[event.chatroom.channelUUID] = streamSub;

    // Insert new chatroom at the start of the chatroom array.
    state.chatrooms.insert(0, event.chatroom);

    final newPrivateChatStreamMap = Map.of(state.privateChatStreamMap);

    yield InquiryChatroomsState.updateChatrooms(
      state,
      privateChatStreamMap: newPrivateChatStreamMap,
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

    // Update latest message for each chatroom. This message is being displayed in inquiry chatroom list is being displayed in inquiry chatroom list
    final chatroomLastMessage = state.chatroomLastMessage;
    for (final chatroom in event.chatrooms) {
      if (chatroom.messages.length > 0) {
        chatroomLastMessage[chatroom.channelUUID] = chatroom.messages[0];
      }
    }

    yield InquiryChatroomsState.updateChatrooms(
      state,
      chatrooms: [...event.chatrooms],
      privateChatStreamMap: newPrivateChatStreamMap,
      chatroomLastMessage: chatroomLastMessage,
    );
  }

  _handlePrivateChatEvent(String channelUUID, QuerySnapshot event) async {
    developer.log('handle private chat on channel ID: $channelUUID');

    final message = Message.fromMap(
      event.docChanges.first.doc.data(),
    );

    //check whether inquirer_uuid or picker_uuid is me,
    //get is read
    String UserUUID = await SecureStore().readUuid();
    final parent = event.docChanges.first.doc.reference.parent.parent.get();
    await parent.then((doc) {
      if (UserUUID == doc.data()["inquirer_uuid"]) {
        message.isRead = doc.data()["inquirer_is_read"];
      }

      if (UserUUID == doc.data()["picker_uuid"]) {
        message.isRead = doc.data()["picker_is_read"];
      }
    });

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

  Stream<InquiryChatroomsState> _mapLeaveMaleChatroomToState(
      LeaveMaleChatroom event) async* {
    // Unsubscribe specified private chat stream.
    if (state.privateChatStreamMap.containsKey(event.channelUUID)) {
      final stream = state.privateChatStreamMap[event.channelUUID];

      stream.cancel();

      state.privateChatStreamMap.remove(event.channelUUID);

      state.chatrooms
          .removeWhere((element) => element.channelUUID == event.channelUUID);

      yield InquiryChatroomsState.updateChatrooms(state);
    } else {
      developer.log(
        'Stream intends to unsubscribe is\'t exist for the given  channel UUID',
        name: 'private_chat:unsubscribe_stream',
      );
    }
  }

  Stream<InquiryChatroomsState> _mapFetchChatroomToState(
      FetchChatrooms event) async* {
    try {
      yield InquiryChatroomsState.loading(state);
      yield InquiryChatroomsState.clearInqiuryChatList(state);

      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await inquiryChatroomApis.fetchInquiryChatrooms(
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

      add(AddChatrooms(chatrooms));
    } on APIException catch (err) {
      developer.log(
        err.toString(),
        name: "APIException: fetch_chats_bloc",
      );

      yield InquiryChatroomsState.loadFailed(state, err);
    } catch (e) {
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

  Stream<InquiryChatroomsState> _mapLoadMoreChatroomsToState(
      LoadMoreChatrooms event) async* {
    try {
      // yield InquiryChatroomsState.loading(state);
      final offset = calcNextPageOffset(
        nextPage: state.currentPage + 1,
        perPage: event.perPage,
      );

      final resp = await inquiryChatroomApis.fetchInquiryChatrooms(
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

  Stream<InquiryChatroomsState> _mapClearInquiryListToState(
      ClearInquiryList event) async* {
    yield InquiryChatroomsState.init();
  }
}
