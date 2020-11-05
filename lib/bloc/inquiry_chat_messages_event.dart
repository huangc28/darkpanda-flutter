part of 'inquiry_chat_messages_bloc.dart';

class InquiryChatMessagesEvent extends Equatable {
  const InquiryChatMessagesEvent();

  @override
  List<Object> get props => [];
}

class DispatchMessage extends InquiryChatMessagesEvent {
  final String chatroomUUID;
  final Message message;

  const DispatchMessage({
    this.chatroomUUID,
    this.message,
  });
}

class FetchHistoricalMessages extends InquiryChatMessagesEvent {
  final String channelUUID;

  const FetchHistoricalMessages({
    this.channelUUID,
  });
}

class RemovePrivateChatRoom extends InquiryChatMessagesEvent {
  final String chatroomUUID;

  const RemovePrivateChatRoom({
    this.chatroomUUID,
  });
}
