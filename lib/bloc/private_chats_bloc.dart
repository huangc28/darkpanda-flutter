import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/models/message.dart';

part 'private_chats_event.dart';
part 'private_chats_state.dart';

class PrivateChatsBloc extends Bloc<PrivateChatsEvent, PrivateChatsState> {
  PrivateChatsBloc() : super(PrivateChatsState.init());

  @override
  Stream<PrivateChatsState> mapEventToState(
    PrivateChatsEvent event,
  ) async* {
    if (event is DispatchMessage) {
      yield* _mapDispatchMessageToState(event);
    } else if (event is RemovePrivateChatRoom) {
      yield* _mapRemovePrivateChatRoomToState(event);
    } else if (event is FetchChatRooms) {
      yield* _mapFetchChatRoomsToState(event);
    }
  }

  Stream<PrivateChatsState> _mapDispatchMessageToState(
      DispatchMessage event) async* {
    developer.log(
      'Incoming message to be dispatched: ${event.chatroomUUID}, ${event.message.toString()}',
      name: 'private_chats:dispatch_message',
    );

    // Merge incoming message to appropriate channel uuid.
    state.chatroomMessages[event.chatroomUUID] =
        state.chatroomMessages.update(event.chatroomUUID, (value) {
      value.add(event.message);

      return value;
    }, ifAbsent: () => [event.message]);

    yield PrivateChatsState.updateChatRoomMessage(state.chatroomMessages);
  }

  Stream<PrivateChatsState> _mapRemovePrivateChatRoomToState(
      RemovePrivateChatRoom event) async* {
    // Check if `channelUUID` exists in map. If it exists, drop the key value pair.
    if (state.chatroomMessages.containsKey(event.chatroomUUID)) {
      developer.log(
        'Removing chatroom and it\'s messages: ${event.chatroomUUID}',
      );

      state.chatroomMessages.remove(event.chatroomUUID);
    }

    yield null;
  }

  Stream<PrivateChatsState> _mapFetchChatRoomsToState(
      FetchChatRooms event) async* {
    //   try {
    //     yield FetchChatsState.loading();

    //     final resp = await inquiryChatsApis.fetchChats();

    //     print('DEBUG *&^ ${resp.body}');

    //     yield null;
    //   } on Error catch (e) {
    //     print('DEBUG trigger _mapFetchChatsToState 2 ${e.toString()}');
    //   }
  }
}
