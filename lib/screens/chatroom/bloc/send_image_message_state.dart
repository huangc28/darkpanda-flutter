part of 'send_image_message_bloc.dart';

enum SendMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class SendImageMessageState<E extends AppBaseException> extends Equatable {
  const SendImageMessageState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  SendImageMessageState.init() : this._(status: AsyncLoadingStatus.initial);

  SendImageMessageState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  SendImageMessageState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: error,
        );

  SendImageMessageState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [status];
}
