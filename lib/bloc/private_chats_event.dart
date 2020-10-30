part of 'private_chats_bloc.dart';

class PrivateChatsEvent extends Equatable {
  const PrivateChatsEvent();

  @override
  List<Object> get props => [];
}

class DispatchMessage extends PrivateChatsEvent {
  final String chatroomUUID;
  final Message message;

  const DispatchMessage({
    this.chatroomUUID,
    this.message,
  });
}

class RemovePrivateChatRoom extends PrivateChatsEvent {
  final String chatroomUUID;

  const RemovePrivateChatRoom({
    this.chatroomUUID,
  });
}
