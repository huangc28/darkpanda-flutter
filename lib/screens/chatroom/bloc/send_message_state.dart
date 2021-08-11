part of 'send_message_bloc.dart';

class SendMessageState<E extends AppBaseException> extends Equatable {
  const SendMessageState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  SendMessageState.init() : this._(status: AsyncLoadingStatus.initial);

  SendMessageState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  SendMessageState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: error,
        );

  SendMessageState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [status];
}
