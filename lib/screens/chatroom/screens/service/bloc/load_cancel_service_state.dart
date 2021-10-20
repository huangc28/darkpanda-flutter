part of 'load_cancel_service_bloc.dart';

class LoadCancelServiceState<E extends AppBaseException> extends Equatable {
  const LoadCancelServiceState._({
    this.status,
    this.loadCancelServiceResponse,
    this.error,
  });

  final AsyncLoadingStatus status;
  final LoadCancelServiceResponse loadCancelServiceResponse;

  final E error;

  const LoadCancelServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadCancelServiceState.loading(LoadCancelServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadCancelServiceState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadCancelServiceState.loaded(
    LoadCancelServiceState state, {
    LoadCancelServiceResponse loadCancelServiceResponse,
  }) : this._(
          status: AsyncLoadingStatus.done,
          loadCancelServiceResponse: loadCancelServiceResponse,
        );

  const LoadCancelServiceState.clearState()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        error,
        loadCancelServiceResponse,
      ];
}
