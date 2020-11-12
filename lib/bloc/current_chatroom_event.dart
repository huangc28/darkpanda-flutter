part of 'current_chatroom_bloc.dart';

abstract class CurrentChatroomEvent extends Equatable {
  const CurrentChatroomEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricalMessages extends CurrentChatroomEvent {
  final String channelUUID;

  const FetchHistoricalMessages({
    this.channelUUID,
  });
}

class FetchMoreHistoricalMessages extends CurrentChatroomEvent {
  final String channelUUID;
  final int perPage;

  const FetchMoreHistoricalMessages({
    this.channelUUID,
    this.perPage = 10,
  });
}

class InitCurrentChatroom extends CurrentChatroomEvent {
  final String channelUUID;

  const InitCurrentChatroom({
    this.channelUUID,
  });
}

class DispatchNewMessage extends CurrentChatroomEvent {
  final Message message;

  const DispatchNewMessage({
    this.message,
  });

  @override
  List<Object> get props => [message];
}
