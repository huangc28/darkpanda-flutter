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
