part of 'inquiry_chat_messages_bloc.dart';

typedef LastMessageGetter = Message Function(String channelUUID);

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

  LastMessageGetter get lastMessage {
    return (String channelUUID) {
      if (!chatroomMessages.containsKey(channelUUID)) {
        developer.log(
          'Trying to access last message from an non-existed chatroom',
        );
        return Message(content: '');
      }

      return chatroomMessages[channelUUID].first;
    };
  }

  @override
  List<Object> get props => [
        chatroomMessages,
      ];
}
