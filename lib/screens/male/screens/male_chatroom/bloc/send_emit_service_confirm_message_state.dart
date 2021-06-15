part of 'send_emit_service_confirm_message_bloc.dart';

class SendEmitServiceConfirmMessageState<E extends AppBaseException>
    extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const SendEmitServiceConfirmMessageState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const SendEmitServiceConfirmMessageState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const SendEmitServiceConfirmMessageState.loading(
      SendEmitServiceConfirmMessageState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const SendEmitServiceConfirmMessageState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const SendEmitServiceConfirmMessageState.done(
      SendEmitServiceConfirmMessageState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
