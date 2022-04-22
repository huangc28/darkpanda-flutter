part of 'exit_chatroom_bloc.dart';

abstract class ExitChatroomEvent extends Equatable {
  const ExitChatroomEvent();

  @override
  List<Object> get props => [];
}

class QuitChatroom extends ExitChatroomEvent {
  const QuitChatroom(this.channelUuid);

  final String channelUuid;

  @override
  List<Object> get props => [this.channelUuid];
}
