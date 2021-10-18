part of 'direct_current_chatroom_bloc.dart';

abstract class DirectCurrentChatroomEvent extends Equatable {
  const DirectCurrentChatroomEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricalMessages extends DirectCurrentChatroomEvent {
  final String channelUUID;

  const FetchHistoricalMessages({
    this.channelUUID,
  });
}

class FetchMoreHistoricalMessages extends DirectCurrentChatroomEvent {
  final String channelUUID;
  final int perPage;

  const FetchMoreHistoricalMessages({
    this.channelUUID,
    this.perPage = 15,
  });
}

class InitDirectCurrentChatroom extends DirectCurrentChatroomEvent {
  final String channelUUID;
  final String inquirerUUID;
  final int perPage;

  const InitDirectCurrentChatroom({
    this.channelUUID,
    this.inquirerUUID,
    this.perPage = 15,
  });
}

class DispatchNewMessage extends DirectCurrentChatroomEvent {
  final Message message;

  const DispatchNewMessage({
    this.message,
  });

  @override
  List<Object> get props => [message];
}

class LeaveDirectCurrentChatroom extends DirectCurrentChatroomEvent {
  const LeaveDirectCurrentChatroom();
}
