part of 'send_message_bloc.dart';

enum SendMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class SendMessageState extends Equatable {
  const SendMessageState._({
    this.status,
  });

  final SendMessageStatus status;

  SendMessageState.init()
      : this._(
          status: SendMessageStatus.initial,
        );

  SendMessageState.loading()
      : this._(
          status: SendMessageStatus.loading,
        );

  SendMessageState.loadFailed()
      : this._(
          status: SendMessageStatus.loadFailed,
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
