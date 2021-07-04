part of 'current_service_chatroom_bloc.dart';

abstract class CurrentServiceChatroomEvent extends Equatable {
  const CurrentServiceChatroomEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricalMessages extends CurrentServiceChatroomEvent {
  final String channelUUID;

  const FetchHistoricalMessages({
    this.channelUUID,
  });
}

class FetchMoreHistoricalMessages extends CurrentServiceChatroomEvent {
  final String channelUUID;
  final int perPage;

  const FetchMoreHistoricalMessages({
    this.channelUUID,
    this.perPage = 15,
  });
}

class InitCurrentServiceChatroom extends CurrentServiceChatroomEvent {
  final String channelUUID;
  final String inquirerUUID;
  final int perPage;

  const InitCurrentServiceChatroom({
    this.channelUUID,
    this.inquirerUUID,
    this.perPage = 15,
  });
}

class DispatchNewMessage extends CurrentServiceChatroomEvent {
  final Message message;

  const DispatchNewMessage({
    this.message,
  });

  @override
  List<Object> get props => [message];
}

class LeaveCurrentServiceChatroom extends CurrentServiceChatroomEvent {
  const LeaveCurrentServiceChatroom();
}

class UpdateServiceStatus extends CurrentServiceChatroomEvent {
  final String serviceUuid;
  final ServiceStatus serviceStatus;

  const UpdateServiceStatus({
    this.serviceUuid,
    this.serviceStatus,
  });
}
