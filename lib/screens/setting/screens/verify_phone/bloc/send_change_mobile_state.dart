part of 'send_change_mobile_bloc.dart';

class SendChangeMobileState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final SendChangeMobileResponse sendChangeMobileResponse;
  final int numSend;

  const SendChangeMobileState._({
    this.error,
    this.status,
    this.sendChangeMobileResponse,
    this.numSend,
  });

  /// Bloc yields following states
  SendChangeMobileState.initial(int numSend)
      : this._(
          status: AsyncLoadingStatus.initial,
          numSend: numSend,
        );

  SendChangeMobileState.loading(SendChangeMobileState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          numSend: state.numSend,
        );

  SendChangeMobileState.error(
    SendChangeMobileState state, {
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: state.error,
          numSend: state.numSend,
        );

  SendChangeMobileState.done(
    SendChangeMobileState state, {
    SendChangeMobileResponse sendChangeMobileResponse,
    int numSend,
  }) : this._(
          status: AsyncLoadingStatus.done,
          sendChangeMobileResponse:
              sendChangeMobileResponse ?? state.sendChangeMobileResponse,
          numSend: numSend ?? state.numSend,
        );

  SendChangeMobileState.resetNumSend(SendChangeMobileState state)
      : this._(
          status: state.status,
          sendChangeMobileResponse: state.sendChangeMobileResponse,
          numSend: 0,
        );

  @override
  List<Object> get props => [
        error,
        status,
        sendChangeMobileResponse,
        numSend,
      ];
}
