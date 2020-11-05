part of 'inquiry_chat_messages_bloc.dart';

typedef LastMessageGetter = Message Function(String channelUUID);

enum FetchHistoricalMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class PrivateChatsState<E extends AppBaseException> extends Equatable {
  final FetchHistoricalMessageStatus status;
  final E error;

  const PrivateChatsState._({
    this.chatroomMessages,
    this.status,
    this.error,
  });

  PrivateChatsState.init()
      : this._(
          chatroomMessages: {},
          status: FetchHistoricalMessageStatus.initial,
        );

  PrivateChatsState.loading(PrivateChatsState state)
      : this._(
          chatroomMessages: state.chatroomMessages,
          status: FetchHistoricalMessageStatus.loading,
        );

  PrivateChatsState.loadFailed(PrivateChatsState state, E err)
      : this._(
          chatroomMessages: state.chatroomMessages,
          status: FetchHistoricalMessageStatus.loadFailed,
          error: err,
        );

  PrivateChatsState.loaded(Map<String, List<Message>> chatroomMessages)
      : this._(
          status: FetchHistoricalMessageStatus.loaded,
          chatroomMessages: chatroomMessages,
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
