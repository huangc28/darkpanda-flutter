part of 'send_emit_service_confirm_message_bloc.dart';

class SendEmitServiceConfirmMessageState<E extends AppBaseException>
    extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final EmitServiceConfirmMessageResponse emitServiceConfirmMessageResponse;

  const SendEmitServiceConfirmMessageState._({
    this.error,
    this.status,
    this.emitServiceConfirmMessageResponse,
  });

  /// Bloc yields following states
  SendEmitServiceConfirmMessageState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          emitServiceConfirmMessageResponse: null,
        );

  SendEmitServiceConfirmMessageState.loading(
      SendEmitServiceConfirmMessageState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          emitServiceConfirmMessageResponse:
              state.emitServiceConfirmMessageResponse,
        );

  SendEmitServiceConfirmMessageState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  SendEmitServiceConfirmMessageState.done(
    SendEmitServiceConfirmMessageState state, {
    EmitServiceConfirmMessageResponse emitServiceConfirmMessageResponse,
  }) : this._(
          status: AsyncLoadingStatus.done,
          emitServiceConfirmMessageResponse: emitServiceConfirmMessageResponse,
        );

  @override
  List<Object> get props => [
        error,
        status,
        emitServiceConfirmMessageResponse,
      ];
}
