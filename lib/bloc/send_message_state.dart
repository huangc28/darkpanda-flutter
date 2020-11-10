part of 'send_message_bloc.dart';

enum SendMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class SendMessageState<E extends AppBaseException> extends Equatable {
  const SendMessageState._({
    this.status,
    this.error,
  });

  final SendMessageStatus status;
  final E error;

  SendMessageState.init()
      : this._(
          status: SendMessageStatus.initial,
        );

  SendMessageState.loading()
      : this._(
          status: SendMessageStatus.loading,
        );

  SendMessageState.loadFailed(E error)
      : this._(
          status: SendMessageStatus.loadFailed,
          error: error,
        );

  SendMessageState.loaded()
      : this._(
          status: SendMessageStatus.loaded,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
