part of 'send_rate_bloc.dart';

class SendRateState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const SendRateState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const SendRateState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const SendRateState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const SendRateState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const SendRateState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
