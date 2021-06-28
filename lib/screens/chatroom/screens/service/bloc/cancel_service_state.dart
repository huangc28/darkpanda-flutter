part of 'cancel_service_bloc.dart';

class CancelServiceState<E extends AppBaseException> extends Equatable {
  const CancelServiceState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;

  final E error;

  const CancelServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const CancelServiceState.loading(CancelServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const CancelServiceState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const CancelServiceState.loaded(CancelServiceState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  const CancelServiceState.clearState()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        error,
      ];
}
