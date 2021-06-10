import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/models/message.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'inquiry_chat_messages_event.dart';
part 'inquiry_chat_messages_state.dart';

/// This bloc stores the messages to be displayed on the inquiry chatroom list.
/// The widget would grab the latest message to display.
/// @TODO rename this bloc to `chatroom_face_message` to clearify it's purpose.
class InquiryChatMessagesBloc
    extends Bloc<InquiryChatMessagesEvent, PrivateChatsState> {
  InquiryChatMessagesBloc() : super(PrivateChatsState.init());

  @override
  Stream<PrivateChatsState> mapEventToState(
    InquiryChatMessagesEvent event,
  ) async* {
    if (event is DispatchMessage) {
      yield* _mapDispatchMessageToState(event);
    } else if (event is RemovePrivateChatRoom) {
      yield* _mapRemovePrivateChatRoomToState(event);
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

    // yield null;
  }

  @override
  void onChange(Change<PrivateChatsState> change) {
    developer.log(
      'Current message state: ${change.currentState.chatroomMessages}',
    );

    developer.log(
      'Next message state: ${change.nextState.chatroomMessages}',
    );

    super.onChange(change);
  }
}
