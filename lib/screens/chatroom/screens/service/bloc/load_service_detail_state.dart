part of 'load_service_detail_bloc.dart';

class LoadServiceDetailState<E extends AppBaseException> extends Equatable {
  const LoadServiceDetailState._({
    this.status,
    this.serviceDetail,
    this.error,
  });

  final AsyncLoadingStatus status;

  final ServiceDetail serviceDetail;

  final E error;

  const LoadServiceDetailState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadServiceDetailState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadServiceDetailState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadServiceDetailState.loaded({
    ServiceDetail serviceDetail,
  }) : this._(
          status: AsyncLoadingStatus.done,
          serviceDetail: serviceDetail,
        );

  const LoadServiceDetailState.clearState()
      : this._(
          serviceDetail: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        error,
        serviceDetail,
      ];
}
