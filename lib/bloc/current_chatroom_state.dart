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
    this.error,
  });

  final FetchHistoricalMessageStatus status;
  final List<Message> historicalMessages;
  final E error;

  CurrentChatroomState.init()
      : this._(
          status: FetchHistoricalMessageStatus.initial,
          historicalMessages: [],
        );

  CurrentChatroomState.loading(CurrentChatroomState state)
      : this._(
          historicalMessages: state.historicalMessages,
          status: FetchHistoricalMessageStatus.loading,
        );

  CurrentChatroomState.loadFailed(CurrentChatroomState state, E error)
      : this._(
          historicalMessages: state.historicalMessages,
          error: error,
          status: FetchHistoricalMessageStatus.loadFailed,
        );

  CurrentChatroomState.loaded(List<Message> historicalMessages)
      : this._(
          status: FetchHistoricalMessageStatus.loaded,
          historicalMessages: historicalMessages,
        );

  @override
  List<Object> get props => [
        status,
        error,
        historicalMessages,
      ];
}
