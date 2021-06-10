part of 'exit_chatroom_bloc.dart';

class ExitChatroomState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const ExitChatroomState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const ExitChatroomState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const ExitChatroomState.loading(ExitChatroomState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const ExitChatroomState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const ExitChatroomState.done(ExitChatroomState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
