part of 'current_chatroom_bloc.dart';

class CurrentChatroomState<E extends AppBaseException> extends Equatable {
  const CurrentChatroomState._({
    this.status,
    this.historicalMessages,
    this.currentMessages,
    this.userProfile,
    this.page,
    this.error,
  });

  final AsyncLoadingStatus status;
  final List<Message> historicalMessages;
  final List<Message> currentMessages;
  final UserProfile userProfile;
  final int page;
  final E error;

  CurrentChatroomState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
          page: 1,
          historicalMessages: [],
          currentMessages: [],
          userProfile: UserProfile(),
        );

  CurrentChatroomState.loading(CurrentChatroomState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          page: state.page,
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          userProfile: state.userProfile,
        );

  CurrentChatroomState.loadFailed(CurrentChatroomState state, E error)
      : this._(
          status: AsyncLoadingStatus.error,
          page: state.page,
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          error: error,
          userProfile: state.userProfile,
        );

  CurrentChatroomState.loaded(
    CurrentChatroomState state, {
    UserProfile inquirerProfile,
    List<Message> historicalMessages,
    int page,
  }) : this._(
          status: AsyncLoadingStatus.done,
          historicalMessages: historicalMessages ?? state.historicalMessages,
          currentMessages: state.currentMessages,
          page: page ?? state.page,
          userProfile: inquirerProfile ?? state.userProfile,
        );

  CurrentChatroomState.updateCurrentMessage(
    CurrentChatroomState state,
    List<Message> currentMessages,
  ) : this._(
          page: state.page,
          status: state.status,
          historicalMessages: state.historicalMessages,
          userProfile: state.userProfile,
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
