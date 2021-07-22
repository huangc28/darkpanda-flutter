part of 'send_register_email_bloc.dart';

class SendRegisterEmailState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final int numSend;

  const SendRegisterEmailState._({
    this.status,
    this.error,
    this.numSend,
  });

  SendRegisterEmailState.initial(int numSend)
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
          numSend: numSend,
        );

  SendRegisterEmailState.sending(SendRegisterEmailState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: m.error,
          numSend: m.numSend,
        );

  SendRegisterEmailState.sendFailed(SendRegisterEmailState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          numSend: m.numSend,
        );

  SendRegisterEmailState.sendSuccess(SendRegisterEmailState m)
      : this._(
          status: AsyncLoadingStatus.done,
          error: m.error,
          numSend: m.numSend,
        );

  factory SendRegisterEmailState.copyFrom(
    SendRegisterEmailState state, {
    E error,
    int numSend,
  }) {
    return SendRegisterEmailState._(
      error: error ?? state.error,
      numSend: numSend ?? state.numSend,
    );
  }

  @override
  List<Object> get props => [
        numSend,
        status,
        error,
      ];
}
