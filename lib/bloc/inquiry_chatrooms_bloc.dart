import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../screens/female/models/picked_inquiry.dart';
import '../models/chatroom.dart';

part 'inquiry_chatrooms_event.dart';
part 'inquiry_chatrooms_state.dart';

class InquiryChatroomsBloc
    extends Bloc<InquiryChatroomsEvent, InquiryChatroomsState> {
  InquiryChatroomsBloc({
    this.inquiryChatMesssagesBloc,
  })  : assert(inquiryChatMesssagesBloc != null),
        super(InquiryChatroomsState.init());

  final InquiryChatMessagesBloc inquiryChatMesssagesBloc;

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

      yield InquiryChatroomsState.updatePrivateChatStreamMap(
        state,
        state.privateChatStreamMap,
      );
    } catch (err) {
      yield InquiryChatroomsState.failed(
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

    yield InquiryChatroomsState.updateChatrooms(
      state,
      state.chatrooms,
    );

    yield InquiryChatroomsState.updatePrivateChatStreamMap(
      state,
      state.privateChatStreamMap,
    );

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

      yield InquiryChatroomsState.updatePrivateChatStreamMap(
        state,
        state.privateChatStreamMap,
      );

      state.chatrooms
          .where((chatroom) => chatroom.channelUUID != event.channelUUID)
          .toList();

      yield InquiryChatroomsState.updateChatrooms(
        state,
        state.chatrooms,
      );

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
}
