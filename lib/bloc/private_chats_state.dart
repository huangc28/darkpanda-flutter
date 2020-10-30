part of 'private_chats_bloc.dart';

class PrivateChatsState extends Equatable {
  const PrivateChatsState._({
    this.chatroomMessages,
  });

  PrivateChatsState.init()
      : this._(
          chatroomMessages: {},
        );

  PrivateChatsState.updateChatRoomMessage(
      Map<String, List<Message>> chatroomMessages)
      : this._(
          chatroomMessages: chatroomMessages,
        );

  final Map<String, List<Message>> chatroomMessages;

  @override
  List<Object> get props => [
        chatroomMessages,
      ];
}
