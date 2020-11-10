part of 'current_chatroom_bloc.dart';

enum FetchHistoricalMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class CurrentChatroomState<E extends AppBaseException> extends Equatable {
  const CurrentChatroomState._({
    this.status,
    this.historicalMessages,
    this.currentMessages,
    this.error,
  });

  final FetchHistoricalMessageStatus status;
  final List<Message> historicalMessages;
  final List<Message> currentMessages;
  final E error;

  CurrentChatroomState.init()
      : this._(
          status: FetchHistoricalMessageStatus.initial,
          historicalMessages: [],
          currentMessages: [],
        );

  CurrentChatroomState.loading(CurrentChatroomState state)
      : this._(
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          status: FetchHistoricalMessageStatus.loading,
        );

  CurrentChatroomState.loadFailed(CurrentChatroomState state, E error)
      : this._(
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          error: error,
          status: FetchHistoricalMessageStatus.loadFailed,
        );

  CurrentChatroomState.loaded(
      CurrentChatroomState state, List<Message> historicalMessages)
      : this._(
          status: FetchHistoricalMessageStatus.loaded,
          historicalMessages: historicalMessages,
          currentMessages: state.currentMessages,
        );

  CurrentChatroomState.updateCurrentMessage(
      CurrentChatroomState state, List<Message> currentMessages)
      : this._(
          status: state.status,
          historicalMessages: state.historicalMessages,
          currentMessages: currentMessages,
        );

  List<Message> get messages {
    return List.from(historicalMessages)..addAll(currentMessages);
  }

  @override
  List<Object> get props => [
        status,
        error,
        historicalMessages,
        currentMessages,
        messages,
      ];
}
